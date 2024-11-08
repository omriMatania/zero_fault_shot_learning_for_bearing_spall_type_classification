function [X_sim, y_sim] = generate_and_process_simulated_dataset_4_CNN(data_path, sim_spall_orders, ...
    num_of_sigs_per_category, new_d_order, num_harmonies, num_of_first_indices_2_set_2_zero)
% generate_simulated_dataset generates the simulated datasets and extracts
% its parameters.

sampling_rate = 50000 ;
shaft_speed = 30 ;
dt = 1 / sampling_rate ;
len_t = 2 * sampling_rate ;
t = [0 : dt : (len_t - 1) * dt].' ;
df = 1 / (len_t * dt) ;
d_order = df / shaft_speed ;
max_ind = ceil(max(sim_spall_orders) * num_harmonies / new_d_order) ;

in_amp = [1, 1, 1] ;
out_amp = 0.5 * in_amp ;
spall_size_range = [0.05, 0.95] ;
up_sampling = 1 ;
rand_sizes = 0 ;
shaft_duty_cycle = 0.3 ;

load([data_path, '\tfs_4_sim\H1.mat']) ;
H1 = H.';
load([data_path, '\tfs_4_sim\H2.mat']) ;
H2 = H.';
load([data_path, '\tfs_4_sim\H3.mat']) ;
H3 = H.';
tfs_f = [H1, H2, H3] ; % 3 transfer functions in the frequency domain.

X_sim = zeros(max_ind, 3 * num_of_sigs_per_category) ;
y_sim = zeros(1, 3 * num_of_sigs_per_category) ;

first_ind = 1 ; step_size = 100 ; last_ind = step_size ;
num_sigs_in_X_sim = 0 ;

disp('Begin to generate and process simulated dataset')
while first_ind <= num_of_sigs_per_category 
    
    disp(['Simulation, number of signals: ', num2str(first_ind), '/', num2str(num_of_sigs_per_category ), ...
        '; t = ', num2str(round(toc()))])
    
    num_sigs = [step_size, step_size, step_size] ;
    spall_types = [1 * ones(1, step_size), 2 * ones(1, step_size), ...
        3 * ones(1, step_size)] ;
    [sigs_time, ~] = generate_simulated_bearing_signals(t, num_sigs, shaft_speed, ...
        sim_spall_orders, spall_size_range, [in_amp; out_amp].', up_sampling, rand_sizes, ...
        tfs_f, shaft_duty_cycle) ;
    
    sigs_order_env = calc_order_of_envelope(sigs_time) ;

    order_old = [0 : d_order : (length(sigs_order_env) - 1) * d_order].' ;
    order_new = [0 : new_d_order : (max_ind - 1) * new_d_order].' ;
    X_sim_batch = interp1(order_old, sigs_order_env, order_new) ;
    
    X_sim_batch(1:num_of_first_indices_2_set_2_zero, :) = ...
        zeros(num_of_first_indices_2_set_2_zero, size(X_sim_batch, 2)) ;
    X_sim_batch = X_sim_batch(1:max_ind, :) ;
    X_sim_batch = X_sim_batch ./ repmat(rms(X_sim_batch), ...
        size(X_sim_batch, 1), 1) ;
     
    X_sim(:, num_sigs_in_X_sim + 1 : num_sigs_in_X_sim + length(spall_types)) = X_sim_batch ;
    y_sim(:, num_sigs_in_X_sim + 1 : num_sigs_in_X_sim + length(spall_types)) = spall_types ;
    num_sigs_in_X_sim = num_sigs_in_X_sim + length(spall_types) ;
    
    first_ind = first_ind + step_size;
    last_ind = min([last_ind + step_size, num_of_sigs_per_category]) ;
    step_size = last_ind - first_ind + 1 ;
    
end
disp('Finished to generate and process simulated dataset')

end
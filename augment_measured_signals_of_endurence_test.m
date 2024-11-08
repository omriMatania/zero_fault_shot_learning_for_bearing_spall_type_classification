function [X, y] = augment_measured_signals_of_endurence_test(dataset, multiply_num, ...
    deviation, bpfo_old, new_spall_frequencies, max_order, d_order_new, len_new, batch_size)

bpfo = new_spall_frequencies(2) ; bpfi = new_spall_frequencies(1) ; 
bsf = new_spall_frequencies(3) ;

try

    sigs = dataset.signals.env.PSD.order ;
    
catch
    
    sigs = dataset.sigs.order ;
    
end

bpfo_new_range = bpfo * [1 - deviation, 1 + deviation] ;
bpfi_new_range = bpfi * [1 - deviation, 1 + deviation] ;
bsf_new_range = bsf * [1 - deviation, 1 + deviation] ;
ds_order_old = dataset.d_order ;

num_new_sigs = multiply_num * size(sigs, 2) ;

d_order_old = min(ds_order_old) ;
order_old = [0 : d_order_old : (size(sigs, 1) - 1) * d_order_old].' ;
max_ind_old = max(find(order_old <= max_order)) ;

X_order = sigs(1 : ceil(1.2 * max([ceil(bpfo_old / min(new_spall_frequencies)), 1])) ...
    * max_ind_old, :) ;

% disp('Begin convert bpfo to new bpfo, new bpfi and new bsf endurence')

r = conver_bpfo_of_env_PSD(X_order(:, 1), ds_order_old, bpfo_old, d_order_new, ...
        bpfo_new_range, len_new, 1) ;
size_1 = size(r, 1) ;

sigs_env_bpfo = zeros(size_1, num_new_sigs) ;
sigs_env_bpfi = zeros(size_1, num_new_sigs) ;
sigs_env_bsf = zeros(size_1, num_new_sigs) ;

first_ind = 1 ; end_ind = batch_size ;
while first_ind <= num_new_sigs
    
%     disp(['Convert ', num2str(first_ind), '/', num2str(size(X_order, 2))])
    
    sigs_env_bpfo(:, first_ind : end_ind) = conver_bpfo_of_env_PSD(...
        X_order(:, first_ind : end_ind), ds_order_old, bpfo_old, d_order_new, ...
        bpfo_new_range, len_new, batch_size) ;
    sigs_env_bpfi(:, first_ind : end_ind) = conver_bpfo_of_env_PSD(...
        X_order(:, first_ind : end_ind), ds_order_old, bpfo_old, d_order_new, ...
        bpfi_new_range, len_new, batch_size) ;
    sigs_env_bsf(:, first_ind : end_ind) = conver_bpfo_of_env_PSD(...
        X_order(:, first_ind : end_ind), ds_order_old, bpfo_old, d_order_new, ...
        bsf_new_range, len_new, batch_size) ;
    
    first_ind = first_ind + batch_size ;
    end_ind = min([end_ind + batch_size, num_new_sigs])  ;
    
    batch_size = end_ind - first_ind + 1 ;

end

% disp(['Finish convert bpfo endurence, t: ', num2str(round(toc()))])

y_bpfo = ones(1, size(sigs_env_bpfo, 2)) ;
y_bpfi = 2 * ones(1, size(sigs_env_bpfi, 2)) ;
y_bsf = 3 * ones(1, size(sigs_env_bsf, 2)) ;

X = [sigs_env_bpfo, sigs_env_bpfi, sigs_env_bsf] ;
y = [y_bpfo, y_bpfi, y_bsf] ;

end


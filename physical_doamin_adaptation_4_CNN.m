function [X, y] = physical_doamin_adaptation_4_CNN(dataset, num_harmonies, num_of_first_indices_2_set_2_zero)
% physical_doamin_adaptation projects the signals into an invarient feature
% space by signal preprocessing based on physical properties of the
% signals.

num_sigs = length(dataset.signals) ; % number of signals
max_ind = ceil(max(dataset.spall_orders) * num_harmonies / dataset.d_order) ;

X = zeros(max_ind, num_sigs) ; % pre-allocation
y = zeros(1, num_sigs) ;

for sig_num = 1 : 1 : num_sigs
    
    signal = dataset.signals{sig_num} ;
    signal_order_env = calc_order_of_envelope(signal) ;
    
    x = signal_order_env ;
    x(1:num_of_first_indices_2_set_2_zero) = zeros(num_of_first_indices_2_set_2_zero, 1) ;
    x = x(1:max_ind) ;

    x = x / rms(x) ;
   
    X(:, sig_num) = x ;
    y(sig_num) = dataset.spall_types(sig_num) ;
    
end % of for

end % of physical_doamin_adaptation
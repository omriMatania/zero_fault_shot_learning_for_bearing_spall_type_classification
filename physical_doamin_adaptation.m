function [X, y] = physical_doamin_adaptation(dataset, num_harmonies, ...
    order_tolerance)
% physical_doamin_adaptation projects the signals into an invarient feature
% space by signal preprocessing based on physical properties of the
% signals.

num_sigs = length(dataset.signals) ; % number of signals

X = zeros(3 * num_harmonies, num_sigs) ; % pre-allocation
y = zeros(1, num_sigs) ;

for sig_num = 1 : 1 : num_sigs
    
    signal = dataset.signals{sig_num} ;
    signal_order_env = calc_order_of_envelope(signal) ;
    
%     signal_order_env(1) = 0 ;
%     plot([0 : dataset.d_order(sig_num) : (length(signal_order_env) - 1) * dataset.d_order(sig_num)], signal_order_env)
%     xlim([0 30])
    
    x = extract_bpfo_bpfi_bsf_values(signal_order_env, dataset.spall_orders(:, sig_num), ...
        dataset.d_order(sig_num), num_harmonies, order_tolerance) ;
    x = x / rms(x) ;
   
    X(:, sig_num) = x ;
    y(sig_num) = dataset.spall_types(sig_num) ;
    
end % of for

end % of physical_doamin_adaptation
function [sigs_env_order, y] = augment_endurence_signals(sigs_env_order, ...
    old_spall_order, new_spall_orders, old_d_order, new_d_order)
% augment_endurence_signals augments the endurence test signals by
% generating new exmples of new spall types.

bpfo = new_spall_orders(1) ; bpfi = new_spall_orders(2) ; bsf = new_spall_orders(3) ;
max_ind = round(size(sigs_env_order, 1) / 3) ;
    
sigs_env_order_bpfo = convert_bpfo_of_env_order_2_new_spall_type(...
    sigs_env_order, old_d_order, new_d_order, old_spall_order, bpfo, max_ind, 'outer race') ;
sigs_env_order_bpfi = convert_bpfo_of_env_order_2_new_spall_type(...
    sigs_env_order, old_d_order, new_d_order, old_spall_order, bpfi, max_ind, 'inner race') ;
sigs_env_order_bsf = convert_bpfo_of_env_order_2_new_spall_type(...
    sigs_env_order, old_d_order, new_d_order, old_spall_order, bsf, max_ind, 'rolling element') ;

y_bpfo = ones(1, size(sigs_env_order_bpfo, 2)) ;
y_bpfi = 2 * ones(1, size(sigs_env_order_bpfi, 2)) ;
y_bsf = 3 * ones(1, size(sigs_env_order_bsf, 2)) ;

sigs_env_order = [sigs_env_order_bpfo, sigs_env_order_bpfi, sigs_env_order_bsf] ;
y = [y_bpfo, y_bpfi, y_bsf] ;

end % augment_endurence_signals


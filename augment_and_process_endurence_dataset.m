function [X_endurence, y_endurence] = augment_and_process_endurence_dataset(database, ...
    num_harmonies, order_tolerance)
% augment_process_endurence_dataset augments the endurence test by generating new
% signals of spalls in the outer race, inner race and in the rolling
% elements.

num_sigs = size(database.signals, 2) ;

X_endurence = zeros(3 * num_harmonies, 3 * num_sigs) ; % pre-allocation
y_endurence = zeros(1, 3 * num_sigs) ;
batch_size = 100 ; first_ind = 1 ; end_ind = batch_size ; x_ind = 1 ;

disp('Begin to augment and process endurence dataset')
while first_ind <= num_sigs
    
    disp(['Endurence test, augment: ', num2str(first_ind), '/', num2str(num_sigs)])
    
    sigs_env_order = database.signals(:, first_ind : end_ind) ;
    [sigs_order_env, y_endurence_batch] = augment_endurence_signals(sigs_env_order, ...
        database.spall_orders(1), database.spall_orders, database.d_order, database.d_order) ;
    
    X_endurence_batch = extract_bpfo_bpfi_bsf_values(sigs_order_env, database.spall_orders, ...
        database.d_order, num_harmonies, order_tolerance) ;
    X_endurence_batch = X_endurence_batch ./ repmat(rms(X_endurence_batch), ...
        size(X_endurence_batch, 1), 1) ;
   
    X_endurence(:, x_ind : x_ind + size(X_endurence_batch, 2) - 1) = X_endurence_batch ;
    y_endurence(x_ind : x_ind + size(X_endurence_batch, 2) - 1) = y_endurence_batch ;
   
    first_ind = first_ind + batch_size ; end_ind = min([end_ind + batch_size, num_sigs]) ;
    batch_size = end_ind - first_ind + 1 ; x_ind = x_ind + size(X_endurence_batch, 2) ;
    
end % of while
disp('Finished to augment and process endurence dataset')

end % of augment_process_endurence_dataset
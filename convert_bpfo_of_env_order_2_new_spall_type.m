function sigs_env_order_new = convert_bpfo_of_env_order_2_new_spall_type(...
    sigs_env_order_old, old_d_order, new_d_order, old_spall_order, new_spall_order, len_new, ...
    new_spall_type)
% convert_bpfo_of_env_order_2_new_spall_type converts signals with outer
% race spall to a new spall type.

len_old = size(sigs_env_order_old, 1) ;

rectified_d_order = (new_spall_order / old_spall_order) * old_d_order ;
rectified_order = [0 : rectified_d_order : (len_old - 1) * rectified_d_order].' ;

order_new = [0 : new_d_order : (len_new - 1) * new_d_order].' ;

sigs_env_order_new = interp1(rectified_order, sigs_env_order_old, order_new) ;

if strcmp(new_spall_type, 'inner race') || strcmp(new_spall_type, 'rolling element')
    sigs_env_order_new = 0.5 * sigs_env_order_new ;
end

end % convert_bpfo_of_env_order_2_new_spall_type


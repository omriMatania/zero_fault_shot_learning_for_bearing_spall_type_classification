function [X, selected_inds] = extract_bpfo_bpfi_bsf_values(sigs_order_env, spalls_orders, ...
    d_order, num_harmonies, order_tolerance)
% extract_bpfo_bpfi_bsf_values extractes the values of the bpfo, bpfi and
% bsf.

X = zeros(3 * num_harmonies, size(sigs_order_env, 2)) ;
selected_inds = zeros(3 * num_harmonies, size(sigs_order_env, 2)) ;

for sig_num = 1 : 1 : size(sigs_order_env, 2)
    
    for spall_type = 1 : 1 : 3 % Outer race, Inner race, Ball fault

        spall_order = spalls_orders(spall_type) ;

        for ii = 1 : 1 : num_harmonies

            order = ii * spall_order ;
            order_max = (1 + order_tolerance) * order ;
            order_min = (1 - order_tolerance) * order ;

            order_max_ind = ceil(order_max / d_order) ;
            order_min_ind = floor(order_min / d_order) ;

            [order_range_amp, max_ind] = max(sigs_order_env(...
                order_min_ind : order_max_ind, sig_num)) ;

            feature_ind = (spall_type - 1) * num_harmonies + ii ;
            selected_inds(feature_ind, sig_num) = (order_min_ind - 1) + max_ind ;
            X(feature_ind, sig_num) = order_range_amp ;

        end % of for

    end % of for

end % of for

end % of extract_bpfo_bpfi_bsf_values
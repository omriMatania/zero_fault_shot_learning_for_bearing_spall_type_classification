function [sigs_t, spall_sizes] = generate_simulated_bearing_signals(t, num_sigs, ...
    shaft_speed, spall_orders, spall_size_range, in_out_amplitudes, up_sampling, ...
    rand_sizes, Hs_f, shaft_duty_cycle)

sigs_t = zeros(length(t), sum(num_sigs)) ;
spall_sizes = zeros(1, sum(num_sigs)) ;

for sig_type = 1 : 1 : 3
    
    if rand_sizes
    
        spall_sizes(sum(num_sigs(1 : sig_type - 1)) + 1 : sum(num_sigs(1 : sig_type))) = ...
            spall_size_range(1) + (spall_size_range(2) - spall_size_range(1)) * rand(1, num_sigs(sig_type)) ;
        
    else
        
        spall_sizes(sum(num_sigs(1 : sig_type - 1)) + 1 : sum(num_sigs(1 : sig_type))) = ...
            linspace(spall_size_range(1), spall_size_range(2), num_sigs(sig_type)) ;
        
    end
    
    in_amp = in_out_amplitudes(sig_type, 1) ;
    out_amp = in_out_amplitudes(sig_type, 2) ;
    
    for ii = 1 : 1 : num_sigs(sig_type)
        
        sigs_t(:, sum(num_sigs(1 : sig_type - 1)) + ii) = ...
            generate_simulated_bearing_signal(t, shaft_speed, ...
            sig_type, spall_sizes(sum(num_sigs(1 : sig_type - 1)) + ii), ...
            spall_orders(sig_type), up_sampling, in_amp, out_amp, Hs_f(:, sig_type), ...
            shaft_duty_cycle) ;
    
    end
    
end

end


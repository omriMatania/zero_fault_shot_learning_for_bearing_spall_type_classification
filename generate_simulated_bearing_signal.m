function [signal_time] = generate_simulated_bearing_signal(t, shaft_speed, ...
    spall_type, spall_size, bpfi_bpfo_bsf, up_sampling, in_amp, out_amp, ...
    H_f, shaft_duty_cycle)

dt = t(2) - t(1) ;
dt_high = (1 / up_sampling) * dt ;
t_high = [0 : dt_high : t(end)].' ;

delta_t = 1 / (bpfi_bpfo_bsf * shaft_speed) ;
delta_num_points = round(delta_t / dt_high) - 1 ;
delta_series_segment = [1; zeros(delta_num_points - 1, 1)] ;
delta_series = repmat(delta_series_segment, ... 
    ceil(length(t_high) / delta_num_points), 1) ;

delta_series = delta_series(1 : length(t_high)) ;

out_first_ind = 1 + round(delta_num_points * spall_size) ;

signal_time_high = in_amp * delta_series + ...
    out_amp * circshift(delta_series, out_first_ind - 1) ;

signal_time = downsample(signal_time_high, up_sampling) ;
signal_time = signal_time + 0.01*randn(size(signal_time)) ;

modulation_wave = generate_modulation_wave(length(signal_time), ...
    delta_num_points, shaft_duty_cycle) ;
if spall_type == 1 % 'outer race'
    % do nothing
elseif spall_type == 2 % 'inner race'
    signal_time = modulation_wave .* signal_time ;
elseif spall_type == 3 % 'ball'
    signal_time = modulation_wave .* signal_time ;
end

h_t = [real(ifft(H_f)); zeros(length(signal_time) - length(H_f), 1)] ;
signal_time = real(ifft(fft(h_t).*fft(signal_time))) ;

end


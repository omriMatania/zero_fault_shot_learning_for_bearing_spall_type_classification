function [modulation_wave] = generate_modulation_wave(num_points, ...
    sgmnt_num_points, duty_cycle)

N = 2*round(sgmnt_num_points * duty_cycle) ;
sgmnt = sin(2*pi*[0:1:round(N/2)]/N).' ;
sgmnt = [sgmnt; zeros(sgmnt_num_points - length(sgmnt), 1)] ;
modulation_wave = repmat(sgmnt, ceil(num_points / length(sgmnt)), 1) ;

modulation_wave = modulation_wave(1:num_points) ;

end


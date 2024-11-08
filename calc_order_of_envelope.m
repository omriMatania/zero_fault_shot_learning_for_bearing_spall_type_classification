function sigs_order_env = calc_order_of_envelope(sigs_cyc)
% calc_order_of_envelope calculates the envelope of the signal in the order
% domain where the input is in the cycle domain.

x_envelope = hilbert(sigs_cyc) ;
x_envelope_L2 = abs(x_envelope).^2 ;
x_envelope_L2_fft = abs(fft(x_envelope_L2)) ;
sigs_order_env = x_envelope_L2_fft(1 : ceil((length(x_envelope_L2_fft) - 1) / 2) + 1, :) ;

end


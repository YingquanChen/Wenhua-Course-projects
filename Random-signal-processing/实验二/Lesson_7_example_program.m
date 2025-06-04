T = 3;      % signal time_len(s)
Fs = 1000;  % sample rate(Hz)
t = 0:1/Fs:T-1/Fs; % sample point
x = 2*cos(2*pi*t); % signal cos 
subplot(311);
plot(t,x);
title('\fontname{}COSINE signal');
n = sqrt(0.1)*randn(size(t)) %noise
subplot(312);
plot(t,n);
title('\fontname{}Noise signal');
s=x+n;              % signal cos add noise
subplot(313);
plot(t,s);
title('\fontname{}COSINE add Noise signal');

N = 1000; 	               % sequence_len
sigma = sqrt(5);    	% std
x = randn(1,N)*sigma;       % Simulate Gaussian sequence with 
m = mean(x); 		
v = var(x); 
r = xcorr(x,'coeff');  	% Normalizes the sequence so that the autocorrelations at zero lag equal 1
plot(1-N:N-1,r) 		
title('\fontname{}the autocorrelation of Gaussian noise sequence ')



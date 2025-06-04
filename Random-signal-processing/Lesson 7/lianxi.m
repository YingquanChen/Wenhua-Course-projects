N = 1000; % sequence_len
sigma = sqrt(5); % std
x = randn(1,N)*sigma; % Simulate Gaussian sequence with
m = mean(x);
v = var(x);
r = xcorr(x,'coeff'); % Normalizes the sequence so that the autocorrelations at zero lag equal 1
plot(1-N:N-1,r)
title('\fontname{}the autocorrelation of Gaussian noise sequence ')
rng(42);%Set up random number seeds
fs = 1000; % Sample rate
t = 0:1/fs:2-1/fs; % Time vector for 2 seconds

% Generate the signal
w1= 100 * pi;
w2 = 150 * pi;
N_t = sqrt(0.1) * randn(size(t)); % White Gaussian Noise with sigma^2 = 0.1
X_t = sin(w1 * t) + 2 * cos(w2 * t) + N_t;

% Plot the periodogram using rectangular and Hamming windows
figure;
subplot(2,1,1);
periodogram(X_t, rectwin(length(X_t)), [], fs);
title('Periodogram with Rectangular Window');

subplot(2,1,2);
periodogram(X_t, hamming(length(X_t)), [], fs);
title('Periodogram with Hamming Window');


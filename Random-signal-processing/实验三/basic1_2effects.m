rng(42);%Set up random number seeds
fs = 1000; % Sample rate
t = 0:1/fs:2-1/fs; % Time vector for 2 seconds

% Generate the signal
w1= 100 * pi;
w2 = 150 * pi;
% Change sampling rate
fs_high = 2000; % Higher sampling rate
t_high = 0:1/fs_high:2-1/fs_high;
X_t_high = sin(w1 * t_high) + 2 * cos(w2 * t_high) + sqrt(0.1) * randn(size(t_high));

figure;
periodogram(X_t_high, rectwin(length(X_t_high)), [], fs_high);
title('Periodogram with Higher Sampling Rate');

% Change signal length
t_long = 0:1/fs:4-1/fs; % Longer signal (4 seconds)
X_t_long = sin(w1 * t_long) + 2 * cos(w2 * t_long) + sqrt(0.1) * randn(size(t_long));

figure;
periodogram(X_t_long, rectwin(length(X_t_long)), [], fs);
title('Periodogram with Longer Signal Length');

% Change noise power
sigma2_values = [0.01, 0.1, 1, 5];
figure;
for i = 1:length(sigma2_values)
    N_t = sqrt(sigma2_values(i)) * randn(size(t));
    X_t = sin(w1 * t) + 2 * cos(w2 * t) + N_t;
    
    subplot(2, 2, i);
    periodogram(X_t, rectwin(length(X_t)), [], fs);
    title(['\sigma^2 = ', num2str(sigma2_values(i))]);
end

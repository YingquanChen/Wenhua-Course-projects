% Define parameters
f1 = 60; % Frequency for X(t)
f2 = 150; % Frequency for Xn(t)
fs = 1000; % Sampling frequency
T = 4; % Duration of the signal in seconds
variance = 0.1; % Variance of the white Gaussian noise

% Time vector
t = 0:1/fs:T-1/fs;

% Noise
N= sqrt(variance)*randn(size(t));

% Generate stochastic signal X(t)
X_t = sin(2*pi*f1*t) + 2*cos(2*pi*f2*t) + N;

% Autocorrelation
Rx_tau = xcorr(X_t,'coeff');

% Cross-correlation
Xn_t = N;
Rx_n_tau = xcorr(X_t, Xn_t, 'coeff');

% Time lags for autocorrelation and cross-correlation
lags = -length(X_t) + 1:length(X_t) - 1;

% Plotting
figure;

subplot(3,1,1);
plot(t, X_t);
title('Stochastic Signal X(t)');
xlabel('Time (s)');
grid on;

subplot(3,1,2);
plot(lags/fs, Rx_tau);
title('Autocorrelation Rx(τ)');
xlabel('Time Lag (s)');
grid on;

subplot(3,1,3);
plot(lags/fs, Rx_n_tau);
title('Cross-Correlation Rxn(τ)');
xlabel('Time Lag (s)');
grid on;

sgtitle('Stochastic Signal and Correlations');

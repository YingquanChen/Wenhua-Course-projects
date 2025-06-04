rng(42);
% Signal generation parameters
fs = 1000; % Sample rate
t = 0:1/fs:2-1/fs; % Time vector for 2 seconds
w1 = 100 * pi;
w2 = 150 * pi;
N_t = sqrt(0.1) * randn(size(t)); % White Gaussian Noise with sigma^2 = 0.1
X_t = sin(w1 * t) + 2 * cos(w2 * t) + N_t;
% Compute custom Periodogram
[Pxx, f] = customPeriodogram(X_t, fs);

% Compute custom Correlogram
[Pxx_corr, f_corr] = customCorrelogram(X_t, fs);

% Plot custom Periodogram
figure;
subplot(3, 1, 1);
plot(f, 10*log10(Pxx));
title('Custom Periodogram');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

% Plot custom Correlogram
subplot(3, 1, 2);
plot(f_corr, 10*log10(Pxx_corr));
title('Custom Correlogram');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

% Plot default Periodogram for comparison
subplot(3, 1, 3);
periodogram(X_t, rectwin(length(X_t)), [], fs);
title('Default Periodogram');

% Custom Periodogram function
function [Pxx, f] = customPeriodogram(x, fs)
    N = length(x);
    X = fft(x); % Compute the FFT
    Pxx = (1/(fs*N)) * abs(X).^2; % Compute the periodogram
    Pxx = Pxx(1:N/2+1); % Take the positive frequencies
    f = (0:N/2) * (fs/N); % Frequency vector
end

% Custom Correlogram function
function [Pxx, f] = customCorrelogram(x, fs)
    N = length(x);
    rxx = xcorr(x, 'biased'); % Compute the autocorrelation
    rxx = rxx(N:end); % Keep only non-negative lags
    Rxx = fft(rxx); % FFT of the autocorrelation function
    Pxx = (1/fs) * abs(Rxx); % Compute the power spectral density
    Pxx = Pxx(1:N/2+1); % Take the positive frequencies
    f = (0:N/2) * (fs/N); % Frequency vector
end


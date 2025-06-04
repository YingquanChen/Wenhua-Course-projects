% Basic 2: Construct a sinusoidal signal with Gaussian noise and estimate its frequency using autocorrelation

% Parameters
f = 2; % Signal frequency in Hz
phase = 0; % Phase of the signal
samplingRate = 1000; % Sampling rate in Hz
duration = 4; % Duration of the signal in seconds
variance = 0.1; % Variance of the Gaussian noise

% Time vector
t = 0:(1/samplingRate):duration-(1/samplingRate);

% Generate the sinusoidal signal with added Gaussian noise
signal = cos(2 * pi * f * t + phase) + sqrt(variance) * randn(size(t));

% Calculate the autocorrelation of the signal
r = xcorr(signal, 'coeff');

% Find the lag corresponding to the first side peak (ignoring the zero-lag peak)
[~,I] = findpeaks(r(2:end)); % Find peaks, excluding the zero-lag peak
first_side_peak_lag = I(1); % Take the first side peak

% Calculate the period from the first side peak lag
% Since 'coeff' normalization is used, the first side lobe gives us the period directly
period = 1 / (2 * pi * f); % The period of the sinusoid
estimated_frequency = 1 / (period * samplingRate / length(signal)); % Estimate frequency

% Plot the sinusoidal signal with Gaussian noise
figure;
subplot(2,1,1);
plot(t, signal);
title('Sinusoidal Signal with Gaussian Noise');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the autocorrelation
subplot(2,1,2);
lags = -length(r)/2:(length(r)/2)-1;
lags_in_seconds = lags / samplingRate;
plot(lags_in_seconds, r);
title('Autocorrelation of the Signal');
xlabel('Lag (s)');
ylabel('Autocorrelation Value');

% Display the estimated frequency and compare it to the true frequency
fprintf('Estimated frequency: %.2f Hz\n', estimated_frequency);
fprintf('True frequency: %.2f Hz\n', f);

% Task: Test the accuracy of frequency estimation for different SNR values
% This would require running the estimation multiple times and possibly
% adjusting the variance parameter to simulate different SNRs.
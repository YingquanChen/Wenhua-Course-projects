rng(42);
fs = 1000; % Sampling rate
t = 0:1/fs:2-1/fs; % Time vector for 2 seconds

omega1 = 100 * pi; % Frequency component 1
omega2 = 150 * pi; % Frequency component 2
sigma2 = 0.1; % Variance of the Gaussian noise

% Generate the interference frequency uniformly in [50*pi, 80*pi]
omegaI = 50 * pi + (80 * pi - 50 * pi) * rand; 

% Initialize the signal
X = sin(omega1 * t) + 2 * cos(omega2 * t) + 4 * cos(omegaI * t) + sqrt(sigma2) * randn(size(t));
M = 100; % Number of runs
N = length(t); % Number of samples
periodograms = zeros(M, N);

for m = 1:M
    omegaI = 50 * pi + (80 * pi - 50 * pi) * rand; % Random interference frequency for each run
    X = sin(omega1 * t) + 2 * cos(omega2 * t) + 4 * cos(omegaI * t) + sqrt(sigma2) * randn(size(t));
    periodograms(m, :) = abs(fftshift(fft(X) / N)).^2; % Compute periodogram using the formula in 11-1
end

% Compute the average periodogram
avg_periodogram = mean(periodograms, 1);
figure;

% Plot periodogram of the 1st run
subplot(2, 1, 1);
plot(linspace(-fs/2, fs/2, N), 10*log10(periodograms(1, :)));
title('Periodogram of 1st run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

% Plot periodogram of the 50th run
subplot(2, 1, 2);
plot(linspace(-fs/2, fs/2, N), 10*log10(periodograms(50, :)));
title('Periodogram of 50th run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

figure;
% Plot periodogram of the 100th run
subplot(2, 1, 1);
plot(linspace(-fs/2, fs/2, N), 10*log10(periodograms(100, :)));
title('Periodogram of 100th run');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

% Plot the average periodogram
subplot(2, 1, 2);
plot(linspace(-fs/2, fs/2, N), 10*log10(avg_periodogram));
title('Average Periodogram over 100 runs');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');

sigma2_values = [0.01, 500, 1000, 5000]; % Different noise variances

figure;
for i = 1:length(sigma2_values)
    sigma2 = sigma2_values(i);
    periodograms = zeros(M, N);
    
    for m = 1:M
        omegaI = 50 * pi + (80 * pi - 50 * pi) * rand;
        X = sin(omega1 * t) + 2 * cos(omega2 * t) + 4 * cos(omegaI * t) + sqrt(sigma2) * randn(size(t));
        periodograms(m, :) = abs(fftshift(fft(X) / N)).^2;
    end
    
    avg_periodogram = mean(periodograms, 1);
    freqs = linspace(-fs/2, fs/2, N); % Generate frequency vector
    
    % Plot the average periodogram
    subplot(4, 1, i);
    plot(freqs, 10*log10(avg_periodogram));
    title(['Average Periodogram, \sigma^2 = ' num2str(sigma2)]);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    
    
end


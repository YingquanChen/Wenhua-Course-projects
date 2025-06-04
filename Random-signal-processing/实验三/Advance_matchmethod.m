clc;
clear all;
close all;

rng(42);
% Parameters
fo = 1000; % Initial frequency of the chirp in Hz
k = 12000; % Chirp rate in Hz/s
T = 0.1; % Duration of the chirp in seconds
Fs = 50000; % Sampling frequency in Hz
t = 0:1/Fs:T-1/Fs; % Time vector
signal = cos(2*pi*(fo*t + 0.5*k*t.^2)); 
N = length(t); % Number of samples for the signal

% Parameters for the full signal (1 second)
T_full = 1; % Duration of the full signal in seconds

N_full = T_full * Fs; % Number of samples for the full signal,in order to determine the origin of the received signal

% Testing parameters
numTests = 500;

% Define SNR ranges with different step sizes
SNR_range = [-50: 4 :-35,  -30 : 1 : -15, -14:5: 0]; % SNR range in dB

% Initialize variables to store results
MSE = zeros(size(SNR_range));
accuracy = zeros(size(SNR_range));

for snr_idx = 1:length(SNR_range)
    SNR_dB = SNR_range(snr_idx);
    
    % Perform 500 tests for each SNR
    mse_snr = 0;
    correct_count = 0;
    
    % Calculate noise power based on the desired SNR
    signal_power = (signal * signal') / N;
    noise_power = signal_power / (10^(SNR_dB/10));

    for test = 1:numTests
        % Generate random insertion point
        start_point = randi([1, N_full - N]);
        
        % Scale the full noise to the desired noise power
        noise_full = sqrt(noise_power) * randn(1, N_full);
        signal_noise_full = noise_full;
        signal_noise_full(start_point:start_point+N-1) = signal_noise_full(start_point:start_point+N-1) + signal;
        
        % Matched filter to estimate end time
        matched_filter = fliplr(signal); % Time-reverse the original signal
        filtered_output = conv(signal_noise_full, matched_filter);
        
        % Find the peak of the matched filter output
        [~, maxIndex] = max(abs(filtered_output));
        estimated_end_sample = maxIndex - 1;
        
        % Convert sample index to time
        estimated_end_time = estimated_end_sample / Fs;

        % Calculate the actual end time
        actual_end_time = (start_point + N - 1) / Fs;
        
        % Calculate Mean Squared Error (MSE)
        squared_error = (actual_end_time - estimated_end_time)^2;
        mse_snr = mse_snr + squared_error;

        % Check accuracy
        if abs(estimated_end_time - actual_end_time) <= 0.03
            correct_count = correct_count + 1;
        end
    end
    
    % Store MSE and accuracy for this SNR
    MSE(snr_idx) = mse_snr / numTests;
    accuracy(snr_idx) = correct_count / numTests;
end

% Create a table for the results
results_table = table(SNR_range', MSE', accuracy'*100, 'VariableNames', {'SNR (dB)', 'MSE', 'Accuracy (%)'});

% Display the table
disp(results_table);

% Plot MSE vs SNR
figure;
semilogy(SNR_range, MSE, '-o');
title('MSE vs SNR (Log Scale)');
xlabel('SNR (dB)');
ylabel('MSE (Log Scale)');

% Plot accuracy vs SNR
figure;
plot(SNR_range, accuracy*100, '-o');
title('Accuracy vs SNR');
xlabel('SNR (dB)');
ylabel('Accuracy (%)');
ylim([0, 100]);


clc;
clear all;
close all;

rng(40);

% Parameters
fo = 1000; % Initial frequency of the chirp in Hz
k = 12000; % Chirp rate in Hz/s
T = 0.1; % Duration of the chirp in seconds
Fs = 50000; % Sampling frequency in Hz
T_full = 1; % Duration of the full signal in seconds
N_full = T_full * Fs; % Number of samples for the full signal

numTests = 500;
SNR_range = [-40: 4 :-24,  -22 : 1 : -5, -3:5: 20]; % SNR range in dB

% Initialize variables to store results
MSE = zeros(size(SNR_range));
accuracy = zeros(size(SNR_range));

% Number of repetitions
num_repetitions = 3;

for snr_idx = 1:length(SNR_range)
    SNR_dB = SNR_range(snr_idx);

    % Store errors from each repetition
    errors = zeros(1, num_repetitions);
    estimated_end_times = zeros(1, num_repetitions);
    
    % Perform 500 tests for each SNR
    mse_snr = 0;
    correct_count = 0;
    
    for test = 1:numTests
        % Time vector
        t = 0:1/Fs:T-1/Fs; 
        signal = cos(2*pi*(fo*t + 0.5*k*t.^2)); 
        N = length(t); % Number of samples for the signal
    
        % Calculate noise power based on the desired SNR
        signal_power = (signal * signal') / N;
        noise_power = signal_power / (10^(SNR_dB/10));
    
        % Generate random insertion point within the range of 0 to 0.9 seconds
        start_time = 0.01; % Ensure start_time is between 0.1 and 0.9
        start_point = round(start_time * Fs);
    
        % Scale the full noise to the desired noise power
        noise_full = sqrt(noise_power) * randn(1, N_full);
        signal_noise_full = noise_full;
        signal_noise_full(start_point:start_point+N-1) = signal_noise_full(start_point:start_point+N-1) + signal;
        
        estimated_end_times = zeros(1, num_repetitions);
    
        for rep = 1:num_repetitions
    
            % Window parameters
            window_size = 0.05 * Fs; % 50 ms window
            overlap_size = 0.025 * Fs; % 25 ms overlap
            num_windows = floor((N_full - overlap_size) / (window_size - overlap_size));
            window_function = hanning(window_size); % Hanning window
        
            window_energies = zeros(1, num_windows);
        
            for win_idx = 1:num_windows
                start_sample = (win_idx - 1) * (window_size - overlap_size) + 1;
                end_sample = start_sample + window_size - 1;
        
                if end_sample > N_full
                    break;
                end
        
                windowed_signal = signal_noise_full(start_sample:end_sample) .* window_function';
        
                % Compute energy of the windowed signal
                window_energy = sum(windowed_signal.^2);
                window_energies(win_idx) = window_energy;
            end
        
            % Find the window with the maximum energy
            [~, max_energy_idx] = max(window_energies);
        
            % Ensure the estimated end time does not exceed 1 second and is at least 0.1 second
            estimated_end_time = max(min((max_energy_idx * (window_size - overlap_size) + window_size - 1) / Fs, 1), 0.1);
        
            % Store results
            estimated_end_times(rep) = estimated_end_time;
        end
    
        actual_end_time = start_time + 0.1;
    
        % Calculate median of the results
        median_estimated_end_time = median(estimated_end_times);
        squared_error = (actual_end_time - median_estimated_end_time)^2;
        mse_snr = mse_snr + squared_error;
    
        if abs(actual_end_time - median_estimated_end_time) <= 0.03
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

% Plot MSE with and without log scale
figure;
semilogy(SNR_range, MSE, '-o');
title('MSE vs SNR (Log Scale)');
xlabel('SNR (dB)');
ylabel('MSE (Log Scale)');

% Plot Accuracy
figure;
plot(SNR_range, accuracy*100, '-o');
title('Accuracy vs SNR');
xlabel('SNR (dB)');
ylabel('Accuracy (%)');
ylim([0, 100]);
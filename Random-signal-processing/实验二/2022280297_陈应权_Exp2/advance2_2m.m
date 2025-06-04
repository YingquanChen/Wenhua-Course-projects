clc
clear all
close all

M = 2; % Number of microphones
d = 0.085; % Distance between microphones (in meters)
c = 340; % Speed of sound in air (in meters per second)
N = 44100; % Number of samples in the signal
DOAs_list = asind((-11:11) * c / (N * d)); % List of possible Direction of Arrival (DOA) angles

num_trials = 200; % Number of trials for each SNR value
correct_count = 0;

% Initialize arrays to store accuracy and SNR values
SNR_range = -10:0; % SNR range from -10 dB to 0 dB
accuracy = zeros(size(SNR_range));

% Load the original signal
[sig_ori, FS] = audioread('test_audio.wav');
sig_ori = sig_ori';
Lsig = length(sig_ori);
dt = 1 / N;
t = 0:dt:(Lsig - 1) * dt;

for snr_idx = 1:length(SNR_range)
    SNR_dB = SNR_range(snr_idx);
    correct_count = 0;

    rng(42); % Seed for reproducibility
    for trial = 1:num_trials
    
        random_index = randperm(length(DOAs_list), 1);
        theta = DOAs_list(random_index);
        r = d * sin(deg2rad(abs(theta))); 
        
        % Calculate the microphone distances based on the DOA
        if theta > 0
            Rsm = [r, 0];
        else
            Rsm = [0, r];
        end
    
        TD = Rsm / c; % Time delay for each microphone
        L_TD = TD / dt;
        L_TD = round(L_TD); % Round the lag to the nearest integer
    
        Signal_Received = [];
        Lsig_end = Lsig - max(L_TD);
        signal_power = sig_ori * sig_ori' / Lsig; % Calculate signal power
        noise_power = signal_power / (10^(SNR_dB / 10)); % Calculate noise power
    
        % Generate noisy signals received by each microphone
        for p = 1:M    
            noise = sqrt(noise_power) * randn(1, Lsig);    
            sig_noise =  sig_ori + noise;
            Signal_with_noise = [sqrt(noise_power) * randn(1, L_TD(p)), sig_noise, sqrt(noise_power) * randn(1, max(L_TD) - L_TD(p))]; 
            Signal_Received = [Signal_Received; Signal_with_noise];
        end
    
        x1 = Signal_Received(1,:);  % Microphone 1
        x2 = Signal_Received(2,:);  % Microphone 2
    
        Max_lag = 11; % Maximum lag for cross-correlation
        % Calculate cross-correlation between the two microphones
        R_12 = xcorr(x1, x2, Max_lag, 'coeff'); 
    
        % Find the lag (time delay) with maximum correlation
        [Lag_12_value, Lag_12_index] = max(R_12); 
        Lag_12_estimate = Lag_12_index - (Max_lag+1); % Estimated lag between microphones
    
        % Estimate direction of arrival (DOA)
        r_estimated = Lag_12_estimate * c / N; % Convert lag to distance
        theta_estimated = asind(r_estimated / d); % Calculate estimated angle
    
        error = abs(theta - theta_estimated);
        tolerance = 1e-6;
        if error < tolerance
            correct_count = correct_count + 1;    
        end
    end

    % Calculate accuracy percentage
    accuracy(snr_idx) = 100 * correct_count / num_trials;

    % Print accuracy information
    disp(['Accuracy at SNR ', num2str(SNR_dB), ' dB: ', num2str(accuracy(snr_idx)), '%']);
end

% Plot the bar chart
bar(SNR_range, accuracy);
xlabel('SNR (dB)');
ylabel('Accuracy (%)');
title('Accuracy vs SNR');

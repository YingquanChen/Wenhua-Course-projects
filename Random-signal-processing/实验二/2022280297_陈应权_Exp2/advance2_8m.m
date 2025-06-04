clc
clear all
close all

M = 8; % Number of microphones changed to 8
d = 0.085; % Distance between microphones (in meters)
c = 340; % Speed of sound in air (in meters per second)
N = 44100; % Number of samples in the signal

% Generating a list of possible Direction of Arrival (DOA) angles
DOAs_list = asind((-11:11) * c / (N * d));

num_trials = 100; % Number of trials for each SNR value
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
        
        % Calculate the distance from the source to each microphone
        delta_r = d * sin(deg2rad(abs(theta))); 
    
        % Set Rsm based on theta
        if theta > 0
            if delta_r == 0
                Rsm = zeros(1, 8);
            else
                Rsm = (M - 1) * delta_r : -delta_r : 0;
            end
        else
            if delta_r == 0
                Rsm = zeros(1, 8);
            else
                Rsm = 0 : delta_r : (M - 1) * delta_r;
            end
        end
        
        % Calculate Time Delays (TD) for each microphone
        TD = Rsm / c;
        L_TD = TD / dt;
        L_TD = round(L_TD);
        
        Signal_Received=[];
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
        
        % Estimate Time Delays using cross-correlation
        Max_lag = 66; % Maximum lag for cross-correlation
        Lag_estimates_xx = zeros(1, M-1);
        for i = 2:M-1
            [R, ~] = xcorr(Signal_Received(i, :), Signal_Received(i+1, :), Max_lag ,  'coeff');
            [~, idx] = max(R);
            Lag_estimates_xx(i-1) = idx - (Max_lag+1);
        end  
        
        % Determine the most probable lag (delay)
        probable_lag = mode(Lag_estimates_xx);
        
        % Estimate direction of arrival (DOA)
        r_estimated = probable_lag * c / N; % Convert lag to distance
        theta_estimated = asind(r_estimated / d); % Calculate estimated angle
        error = abs(theta - theta_estimated);
        
        % Check if the estimated angle is within tolerance
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

clc; % Clear the command window
clear all; % Clear all variables from the workspace
close all; % Close all open figures
rng(42); % Set the random number generator seed for reproducibility
M = 8; % Number of microphones
d = 0.085; % Distance between microphones
c = 340; % Speed of sound
N = 44100; % Sampling frequency

num_trials = 100; % Number of trials for the simulation

% Initialize arrays to store accuracy and SNR values
SNR_range = -25:10; % Range of SNR values to test

% Read the original audio signal and its sampling frequency
[sig_ori, FS] = audioread('test_audio.wav');
sig_ori = sig_ori'; % Transpose the signal matrix
Lsig = length(sig_ori); % Length of the signal
dt = 1 / N; % Time interval between samples
t = 0:dt:(Lsig - 1) * dt; % Time vector

% Initialize arrays to store error values for each SNR
errors_all = zeros(size(SNR_range)); % Errors for mode lag delay
errors_all_median = zeros(size(SNR_range)); % Errors for median lag delay
errors_all_Interpolation = zeros(size(SNR_range)); % Errors for interpolation lag delay

% Loop over SNR values
for snr_idx = 1:length(SNR_range)
    
    SNR_dB = SNR_range(snr_idx); % Current SNR value

    % Initialize arrays to store errors for each trial
    errors = zeros(num_trials, 1);
    errors_median = zeros(num_trials, 1);
    errors_Interpolation = zeros(num_trials, 1);

    % Loop over trials
    for trial = 1:num_trials

        % Generate random angle theta and calculate the distance delta_r
        theta = unifrnd(-90, 90);
        delta_r = d * sin(deg2rad(abs(theta)));
        
        % Calculate the time difference of arrival (TD) based on theta
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
        
        TD = Rsm / c; % Convert distance to time
        L_TD = TD / dt; % Convert time to number of samples
        L_TD = round(L_TD); % Round to the nearest integer
        
        % Initialize the received signal array
        Signal_Received = [];
        Lsig_end = Lsig - max(L_TD);
        signal_power = sig_ori * sig_ori' / Lsig; % Calculate signal power
        noise_power = signal_power / (10^(SNR_dB / 10)); % Calculate noise power
        
        % Loop over microphones to generate signals with noise
        for p = 1:M    
            noise = sqrt(noise_power) * randn(1, Lsig); % Generate noise
            sig_noise = sig_ori + noise; % Add noise to the original signal
            Signal_with_noise = [sqrt(noise_power) * randn(1, L_TD(p)), sig_noise, sqrt(noise_power) * randn(1, max(L_TD) - L_TD(p))]; 
            Signal_Received = [Signal_Received; Signal_with_noise]; % Concatenate the signals
        end
        
        % Estimate time delays using cross-correlation
        Max_lag = 66; % Maximum lag for cross-correlation
        Lag_estimates_xx = zeros(1, M-1); % Initialize array for lag estimates
        for i = 2:M-1
            [R, ~] = xcorr(Signal_Received(i, :), Signal_Received(i+1, :), Max_lag ,  'coeff');
            [~, idx] = max(R);
            Lag_estimates_xx(i-1) = idx - (Max_lag+1);
        end  
        
        % Calculate the mode, median, and interpolated lag estimates
        mode_lag = mode(Lag_estimates_xx);
        median_lag = median(Lag_estimates_xx); % Median lag to reduce the effect of outliers
        interpolated_lag = interp1(1:M-1, Lag_estimates_xx, 1:0.1:M-1, 'spline'); % Spline interpolation
        refined_lag = median(interpolated_lag); % Median of interpolated lags
        
        % Convert the estimated lags to distances and angles
        r_estimated = mode_lag * c / N;
        r_estimated_Interpolation = refined_lag * c / N;
        r_estimated_median = median_lag * c / N;
        
        theta_estimated = asind(r_estimated / d);
        theta_estimated_median = asind(r_estimated_median / d);
        theta_estimated_Interpolation = asind(r_estimated_Interpolation / d);
        
        % Calculate the errors
        error = abs(theta - theta_estimated);
        error_median = abs(theta - theta_estimated_median);
        error_Interpolation = abs(theta - theta_estimated_Interpolation);
        
        % Store the errors for each trial
        errors(trial) = error;
        errors_median(trial) = error_median;
        errors_Interpolation(trial) = error_Interpolation;
    end

    % Calculate the mean errors for the current SNR value
    errors_all(snr_idx) = mean(errors);
    errors_all_median(snr_idx) = mean(errors_median);
    errors_all_Interpolation(snr_idx) = mean(errors_Interpolation);

    % Display the mean errors for the current SNR value
    disp(['Mode lag delay error at SNR ', num2str(SNR_dB), ' dB: ', num2str(mean(errors))]);
    disp(['Median lag delay error at SNR ', num2str(SNR_dB), ' dB: ', num2str(mean(errors_median))]);
    disp(['Interpolation lag delay error at SNR ', num2str(SNR_dB), ' dB: ', num2str(mean(errors_Interpolation))]);
end

% Plot the results
figure;
plot(SNR_range, errors_all, 'r-', 'LineWidth', 1.5); % Plot mode lag delay errors
hold on;
plot(SNR_range, errors_all_median, 'b-', 'LineWidth', 1.5); % Plot median lag delay errors
plot(SNR_range, errors_all_Interpolation, 'g-', 'LineWidth', 1.5); % Plot interpolation lag delay errors
xlabel('SNR (dB)'); % Label for the x-axis
ylabel('Error'); % Label for the y-axis
title('Different algorithms on lag delay vs SNR'); % Title of the plot
legend('Mode lag delay', 'Median lag delay', 'Interpolation lag delay'); % Legend for the plot
grid on; % Enable grid
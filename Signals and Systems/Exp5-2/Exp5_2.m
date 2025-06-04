% Load the original speech signal (assuming it's already sampled at 16kHz)
[y, fs] = audioread('output_audio_16kHz.wav');

% Ensure the signal length is 5 seconds
desired_duration = 5;  % Target signal duration in seconds
num_samples_target = desired_duration * fs;
y = y(1:min(length(y), num_samples_target));  % Trim or pad to 5 seconds

% Define SNRs to test: 10dB, 0dB, -10dB
snrs = [10, 0, -10];  % in dB

% Initialize arrays to store results
y_noisy = cell(1, length(snrs));  % Noisy speech signals
y_denoised_time = cell(1, length(snrs));  % Denoised speech signals in time domain

% Generate white noise
rng('default');  % Set random seed for reproducibility
for i = 1:length(snrs)
    snr_db = snrs(i);
    
    % Calculate noise power
    signal_power = sum(y.^2) / length(y);
    noise_power = signal_power / (10^(snr_db/10));  % calculate noise power
    
    % Generate white noise with the calculated noise power
    noise = sqrt(noise_power) * randn(size(y));
    
    % Add noise to the original speech signal
    y_noisy{i} = y + noise;
    
    % Frequency domain denoising
    % Perform FFT
    Y_noisy = fft(y_noisy{i});
    freq_axis = linspace(0, fs, length(Y_noisy));  % Frequency axis
    
    % Design frequency filters (simple low-pass filter)
    cutoff_freq = 3000;  % Cut-off frequency in Hz
    H = zeros(size(Y_noisy));
    H(freq_axis < cutoff_freq) = 1;  % pass low frequencies
    H(freq_axis > fs - cutoff_freq) = 1;  % pass high frequencies
    
    % Apply the filter in frequency domain
    Y_denoised_freq = Y_noisy .* H;
    
    % Perform inverse FFT to get time domain signal
    y_denoised_freq = ifft(Y_denoised_freq, 'symmetric');
    
    % Time domain denoising (optional for comparison)
    % Design corresponding time domain filter (impulse response)
    h_time = ifft(H, 'symmetric');
    
    % Apply time domain filter to noisy speech signal
    y_denoised_time{i} = conv(y_noisy{i}, h_time, 'same');
    
    % Normalize the denoised signals
    y_denoised_time{i} = y_denoised_time{i} / max(abs(y_denoised_time{i}));
    
    % Plotting for comparison
    figure;
    subplot(3, 1, 1);
    plot(y);
    title('Original Signal');
    xlabel('Time (samples)');
    ylabel('Amplitude');
    
    subplot(3, 1, 2);
    plot(y_noisy{i});
    title(sprintf('Noisy Signal (SNR = %d dB)', snr_db));
    xlabel('Time (samples)');
    ylabel('Amplitude');
    
    subplot(3, 1, 3);
    plot(y_denoised_freq);
    title('Denoised Signal (Frequency Domain)');
    xlabel('Time (samples)');
    ylabel('Amplitude');
    
    sgtitle(sprintf('Speech Signal Denoising Comparison (SNR = %d dB)', snr_db));
    
    % Adjust figure size for clarity
    set(gcf, 'Position', [100, 100, 800, 600]);
    
    % Save denoised signals as WAV files
    filename_denoised_freq = sprintf('denoised_signal_freq_domain_%ddb.wav', snr_db);
    audiowrite(filename_denoised_freq, y_denoised_freq, fs);
    
    filename_denoised_time = sprintf('denoised_signal_time_domain_%ddb.wav', snr_db);
    audiowrite(filename_denoised_time, y_denoised_time{i}, fs);
    
    % Save noisy signal as WAV file
    filename_noisy = sprintf('noisy_signal_%ddb.wav', snr_db);
    audiowrite(filename_noisy, y_noisy{i}, fs);
end







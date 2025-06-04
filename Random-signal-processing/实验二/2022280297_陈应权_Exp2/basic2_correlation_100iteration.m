% Parameters
num_iterations = 100;      % Number of iterations
true_frequency = 88.8;     % True frequency of the sinusoidal signal (Hz)
Fs = 1000;                 % Sampling frequency (Hz)
T = 1/Fs;                  % Sampling period
theta = 0;                 % Phase
variances = [0.5, 1, 1.5]; % Variance values for Gaussian noise

for var_idx = 1:length(variances)
    variance = variances(var_idx);

    % Initialize error vector
    errors = zeros(1, num_iterations);

    % Loop for num_iterations
    for i = 1:num_iterations
        % Generate sinusoidal signal
        t = 0:T:1;                                      % Time vector
        x = cos(2*pi*true_frequency*t + theta);         % True sinusoidal signal

        % Generate Gaussian noise
        Nt = sqrt(variance) * randn(size(t));           % Gaussian noise with specified variance

        % Add noise to the signal
        X = x + Nt;

        % Compute autocorrelation of the windowed signal
        Rx = xcorr(X, 'coeff');

        % Use findpeaks with minimum peak distance and height
        [~, peak_locs] = findpeaks(Rx);

        % Count the number of points N between adjacent peaks
        N = mean(diff(peak_locs));

        % Estimate signal period
        period = (mean(N) + 1) * T;

        % Estimate signal frequency
        estimated_frequency = 1 / period;

        % Calculate error in frequency estimation
        errors(i) = abs(estimated_frequency - true_frequency);
    end

    % Plot histogram of errors
    figure;
    histogram(errors, 'BinWidth', 0.5);
    title(['Histogram of Frequency Estimation Errors (Variance = ', num2str(variance), ')']);
    xlabel('Error (Hz)');
    ylabel('Frequency of Occurrence');

    % Calculate average error
    average_error = mean(errors);

    % Print average error and variance
    fprintf('Average frequency estimation error over %d iterations: %.2f Hz when variance is %.2f\n', num_iterations, average_error, variance);
end

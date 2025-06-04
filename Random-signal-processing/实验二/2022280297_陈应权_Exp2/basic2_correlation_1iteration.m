% Parameters
true_frequency = 100;   % True frequency of the sinusoidal signal (Hz)
Fs = 1000;               % Sampling frequency (Hz)
T = 1/Fs;                % Sampling period
theta = 0;               % Phase
variances = [0.5, 1, 1.5]; % Variance values for Gaussian noise

for var_idx = 1:length(variances)
    variance = variances(var_idx);

    % Generate sinusoidal signal
    t = 0:T:1;            % Time vector
    x = cos(2*pi*true_frequency*t + theta);  % True sinusoidal signal

    % Generate Gaussian noise
    Nt = sqrt(variance) * randn(size(t));     % Gaussian noise with specified variance

    % Add noise to the signal
    X = x + Nt;

    % Compute autocorrelation of the windowed signal
    Rx = xcorr(X, 'coeff');

    % Plot the autocorrelation
    figure;
    plot(Rx)
    title(['Autocorrelation Function for One Run (Variance = ', num2str(variance), ')'])
    xlabel('Lag')
    ylabel('Autocorrelation Coefficient')
    hold on

    % Use findpeaks with minimum peak distance and height
    [peaks, peak_locs] = findpeaks(Rx);

    % Overlay the peak locations on the autocorrelation plot
    for loc = peak_locs
        plot(loc, peaks(peak_locs == loc), 'ro')  % 'ro' is for red circle markers
    end

    % Count the number of points N between adjacent peaks
    N = mean(diff(peak_locs));

    % Estimate signal period
    period = (mean(N) + 1) * T;

    % Estimate signal frequency
    estimated_frequency = 1 / period;

    % Calculate error in frequency estimation
    errors = abs(estimated_frequency - true_frequency);

    % Display the estimated frequency and the error
    fprintf('Estimated frequency: %.2f Hz, Error: %.2f Hz when variance is %.2f\n', estimated_frequency, errors, variance);
end





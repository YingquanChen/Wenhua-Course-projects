% Parameters
num_samples_50 = 50;
num_samples_5000 = 5000;

% Generate random samples
x_uniform_50 = rand(1, num_samples_50);
x_uniform_5000 = rand(1, num_samples_5000);

% Plot for Uniform distribution with 50 samples
figure;
histogram(x_uniform_50, 'Normalization', 'pdf');
hold on;
[f_uniform_50, xi_uniform_50] = ksdensity(x_uniform_50);
plot(xi_uniform_50, f_uniform_50, 'r', 'LineWidth', 1.5);
x = linspace(0, 1, 100);
y = unifpdf(x, 0, 1); % True PDF
plot(x, y, 'g', 'LineWidth', 1.5);
title('PDF of Uniform Distribution (50 samples)');
legend('Histogram', 'Estimated PDF', 'True PDF');
hold off;

% Plot for Uniform distribution with 5000 samples
figure;
histogram(x_uniform_5000, 'Normalization', 'pdf');
hold on;
[f_uniform_5000, xi_uniform_5000] = ksdensity(x_uniform_5000);
plot(xi_uniform_5000, f_uniform_5000, 'r', 'LineWidth', 1.5);
x = linspace(0, 1, 100);
y = unifpdf(x, 0, 1); % True PDF
plot(x, y, 'g', 'LineWidth', 1.5);
title('PDF of Uniform Distribution (5000 samples)');
legend('Histogram', 'Estimated PDF', 'True PDF');
hold off;

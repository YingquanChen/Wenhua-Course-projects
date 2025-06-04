% Parameters
num_samples_50 = 50;
num_samples_5000 = 5000;

% Generate random samples
x_exponential_50 = exprnd(1, 1, num_samples_50);
x_exponential_5000 = exprnd(1, 1, num_samples_5000);

% Plot for Exponential distribution with 50 samples
figure;
histogram(x_exponential_50, 'Normalization', 'pdf');
hold on;
[f_exponential_50, xi_exponential_50] = ksdensity(x_exponential_50);
plot(xi_exponential_50, f_exponential_50, 'r', 'LineWidth', 1.5);
x = linspace(0, max(x_exponential_50), 100);
y = exppdf(x, 1); % True PDF
plot(x, y, 'g', 'LineWidth', 1.5);
title('PDF of Exponential Distribution (50 samples)');
legend('Histogram', 'Estimated PDF', 'True PDF');
hold off;

% Plot for Exponential distribution with 5000 samples
figure;
histogram(x_exponential_5000, 'Normalization', 'pdf');
hold on;
[f_exponential_5000, xi_exponential_5000] = ksdensity(x_exponential_5000);
plot(xi_exponential_5000, f_exponential_5000, 'r', 'LineWidth', 1.5);
x = linspace(0, max(x_exponential_5000), 100);
y = exppdf(x, 1); % True PDF
plot(x, y, 'g', 'LineWidth', 1.5);
title('PDF of Exponential Distribution (5000 samples)');
legend('Histogram', 'Estimated PDF', 'True PDF');
hold off;

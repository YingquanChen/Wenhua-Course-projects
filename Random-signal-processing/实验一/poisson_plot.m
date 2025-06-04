% Parameters
num_samples_50 = 50;
num_samples_5000 = 5000;

% Generate random samples
x_poisson_50 = poissrnd(5, 1, num_samples_50);
x_poisson_5000 = poissrnd(5, 1, num_samples_5000);

% Plot for Poisson distribution with 50 samples
figure;
histogram(x_poisson_50, 'Normalization', 'pdf');
hold on;
[f_poisson_50, xi_poisson_50] = ksdensity(x_poisson_50);
plot(xi_poisson_50, f_poisson_50, 'r', 'LineWidth', 1.5);
x = 0:max(x_poisson_50);
y = poisspdf(x, 5); % True PDF
plot(x, y, 'g', 'LineWidth', 1.5);
title('PDF of Poisson Distribution (50 samples)');
legend('Histogram', 'Estimated PDF', 'True PDF');
hold off;

% Plot for Poisson distribution with 5000 samples
figure;
histogram(x_poisson_5000, 'Normalization', 'pdf');
hold on;
[f_poisson_5000, xi_poisson_5000] = ksdensity(x_poisson_5000);
plot(xi_poisson_5000, f_poisson_5000, 'r', 'LineWidth', 1.5);
x = 0:max(x_poisson_5000);
y = poisspdf(x, 5); % True PDF
plot(x, y, 'g', 'LineWidth', 1.5);
title('PDF of Poisson Distribution (5000 samples)');
legend('Histogram', 'Estimated PDF', 'True PDF');
hold off;

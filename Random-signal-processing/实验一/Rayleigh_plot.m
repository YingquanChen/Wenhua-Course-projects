% Parameters
num_samples_50 = 50;
num_samples_5000 = 5000;

% Generate random samples
x_rayleigh_50 = raylrnd(1, 1, num_samples_50);
x_rayleigh_5000 = raylrnd(1, 1, num_samples_5000);

% Plot for Rayleigh distribution with 50 samples
figure;
histogram(x_rayleigh_50, 'Normalization', 'pdf');
hold on;
[f_rayleigh_50, xi_rayleigh_50] = ksdensity(x_rayleigh_50);
plot(xi_rayleigh_50, f_rayleigh_50, 'r', 'LineWidth', 1.5);
x = linspace(min(x_rayleigh_50), max(x_rayleigh_50), 100);
y = raylpdf(x, 1); % True PDF
plot(x, y, 'g', 'LineWidth', 1.5);
title('PDF of Rayleigh Distribution (50 samples)');
legend('Histogram', 'Estimated PDF', 'True PDF');
hold off;

% Plot for Rayleigh distribution with 5000 samples
figure;
histogram(x_rayleigh_5000, 'Normalization', 'pdf');
hold on;
[f_rayleigh_5000, xi_rayleigh_5000] = ksdensity(x_rayleigh_5000);
plot(xi_rayleigh_5000, f_rayleigh_5000, 'r', 'LineWidth', 1.5);
x = linspace(min(x_rayleigh_5000), max(x_rayleigh_5000), 100);
y = raylpdf(x, 1); % True PDF
plot(x, y, 'g', 'LineWidth', 1.5);
title('PDF of Rayleigh Distribution (5000 samples)');
legend('Histogram', 'Estimated PDF', 'True PDF');
hold off;



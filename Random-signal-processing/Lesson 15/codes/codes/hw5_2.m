clear
clc

% Transition probability matrix P
P = [0.7 0.1 0.1 0.1;
     0.2 0.4 0.2 0.2;
     0.1 0.1 0.6 0.2;
     0.3 0.0 0.3 0.4];

% Initial market shares (assuming 25% each for A, B, C, D)
initial_market_share = [0.25; 0.25; 0.25; 0.25];

% Simulation parameters
Total_Months = 24;

% Matrix to store market shares over time
MarketShares = zeros(4, Total_Months);
MarketShares(:, 1) = initial_market_share;

% Simulate market shares over Total_Months months
for month = 2:Total_Months
    MarketShares(:, month) = P' * MarketShares(:, month - 1);
end

% Plotting
months = 1:Total_Months;

figure;
plot(months, MarketShares(1, :), '-o', 'LineWidth', 2, 'DisplayName', 'Shampoo A');
hold on;
plot(months, MarketShares(2, :), '-s', 'LineWidth', 2, 'DisplayName', 'Shampoo B');
plot(months, MarketShares(3, :), '-^', 'LineWidth', 2, 'DisplayName', 'Shampoo C');
plot(months, MarketShares(4, :), '-d', 'LineWidth', 2, 'DisplayName', 'Shampoo D');
title('Market Shares of Shampoos');
xlabel('Months');
ylabel('Market Share');
legend('show');
grid on;

% Market shares in month 2 and month 12
disp(['Market shares in month 2:']);
disp(['Shampoo A: ' num2str(MarketShares(1, 2))]);
disp(['Shampoo B: ' num2str(MarketShares(2, 2))]);
disp(['Shampoo C: ' num2str(MarketShares(3, 2))]);
disp(['Shampoo D: ' num2str(MarketShares(4, 2))]);

disp(['Market shares in month 12:']);
disp(['Shampoo A: ' num2str(MarketShares(1, 12))]);
disp(['Shampoo B: ' num2str(MarketShares(2, 12))]);
disp(['Shampoo C: ' num2str(MarketShares(3, 12))]);
disp(['Shampoo D: ' num2str(MarketShares(4, 12))]);
% Extract market shares in month 2 from MarketShares matrix
market_share_month_2 = MarketShares(:, 3);

% Display market shares in month 2
disp(['Market shares in month 2:']);
disp(['Shampoo A: ' num2str(market_share_month_2(1))]);
disp(['Shampoo B: ' num2str(market_share_month_2(2))]);
disp(['Shampoo C: ' num2str(market_share_month_2(3))]);
disp(['Shampoo D: ' num2str(market_share_month_2(4))]);


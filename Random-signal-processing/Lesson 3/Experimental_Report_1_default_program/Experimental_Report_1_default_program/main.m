clear;
clc;
warning off

N_runs = 500;  % Number of independent runs
N_trades = 100;  % Number of trades per run
Return_total_all = zeros(N_runs, 1);  % Store total returns for all runs

for run = 1:N_runs
    % Randomly generate counterparty's betray probability for this run
    counterparty_betray_prob = rand(1);
    
    % Randomly generate counterparty's previous actions for this run
    counterparty_previous_action_list = rand(10, 1);
    counterparty_previous_action = double(counterparty_betray_prob > counterparty_previous_action_list);

    Return_total = 0;  % Initialize return for this run
    
    for n_trade = 1:N_trades
        % Determine your strategy based on the counterparty's previous actions
        Your_Strategy = Your_Strategies(counterparty_previous_action);
        
        % Generate counterparty's action for this trade
        counterparty_action = double(counterparty_betray_prob > rand(1));
        
        % Calculate return for this trade based on your strategy and counterparty's action
        if Your_Strategy == 0
            if counterparty_action == 0
                Return_current = 10;  % Both trust, add 10 points
            else
                Return_current = -5;  % Self-trust, counterparty betrays, -5 points
            end
        else
            Return_current = 0;  % Self-reject, both get 0 points
        end
        
        Return_total = Return_total + Return_current;  % Update total return for this run
    end
    
    Return_total_all(run) = Return_total;  % Store total return for this run
end

% Calculate and display performance metrics
average_return = mean(Return_total_all);
std_dev_return = std(Return_total_all);
max_return = max(Return_total_all);
min_return = min(Return_total_all);

fprintf('Performance Metrics:\n');
fprintf('Average Return: %.2f\n', average_return);
fprintf('Standard Deviation of Returns: %.2f\n', std_dev_return);
fprintf('Maximum Return: %.2f\n', max_return);
fprintf('Minimum Return: %.2f\n', min_return);
% Plot histogram of total returns
figure;
histogram(Return_total_all, 'Normalization', 'probability');
hold on;  % Hold the current plot
title('Histogram of Total Returns');
xlabel('Total Return');
ylabel('Probability');
grid on;

% Plot probability density function (PDF)
figure;
pd = fitdist(Return_total_all, 'Normal');
x_values = min(Return_total_all):0.1:max(Return_total_all);
y_values = pdf(pd, x_values);
plot(x_values, y_values, 'LineWidth', 2);
hold on;  % Hold the current plot
title('Probability Density Function (PDF) of Total Returns');
xlabel('Total Return');
ylabel('Probability Density');
grid on;

% Add a red line at x=0
line([0 0], ylim, 'Color', 'red', 'LineStyle', '--', 'LineWidth', 2);

% Show plots
hold off;  % Release the hold

clear
clc

% Parameters
initial_capital_A = 2;  % Initial capital of Player A
initial_capital_B = 3;  % Initial capital of Player B
p_loss_A = 1/4;          % Probability of A losing a game

% Transition matrix P
P = zeros(initial_capital_A + initial_capital_B + 1);
for i = 1:size(P, 1)
    if i <= initial_capital_A
        % A's turn to play
        if i > 1
            P(i, i-1) = p_loss_A;  % A loses: A's capital decreases by 1
        end
        P(i, i+1) = 1 - p_loss_A;  % A wins: A's capital increases by 1
    elseif i > initial_capital_A + 1
        % B's turn to play
        P(i, i-1) = 1;  % B's capital decreases by 1
    end
end
P(initial_capital_A + 1, 1) = p_loss_A;  % A loses all capital (ruin)
P(initial_capital_A + 1, end) = 1 - p_loss_A;  % A wins and B ruins

% Simulation parameters
Total_Game_No = 20;  % Number of games to simulate

% Initialize probabilities
Prob_of_no_ruin_total = zeros(1, Total_Game_No);

% Initial probability matrix
P_current = eye(initial_capital_A + initial_capital_B + 1);

% Simulate the game over Total_Game_No games
for i = 1:Total_Game_No
    P_current = P_current * P;
    
    % Probability of no ruin for both A and B
    Prob_of_no_ruin_total(i) = 1 - P_current(initial_capital_A + 1, 1) - P_current(initial_capital_A + 1, end);
end

% Plotting
games = 1:Total_Game_No;

figure;
plot(games, Prob_of_no_ruin_total, '-o', 'LineWidth', 2);
xlim([1, Total_Game_No]);
ylim([0, 1]);
title('Probability of No Ruin (Both A and B)');
xlabel('Number of games');
ylabel('Probability');
grid on;

% Probability of no ruin after 10 games
Prob_no_ruin_10_games_total = Prob_of_no_ruin_total(10);
disp(['Probability of no ruin (Both A and B) after 10 games: ' num2str(Prob_no_ruin_10_games_total)]);





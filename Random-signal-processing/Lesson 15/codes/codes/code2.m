clear
clc

P = [1,0,0,0,0,0;0.25,0,0.75,0,0,0;0,0.25,0,0.75,0,0;0,0,0.25,0,0.75,0;0,0,0,0.25,0,0.75;0,0,0,0,0,1];

Prob_of_A_ruin = [];
Prob_of_B_ruin = [];
Prob_of_no_ruin = [];

Total_Game_No = 20;
A_start = 2;
B_start = 3;

P_current = eye(A_start+B_start+1);
games = 1:Total_Game_No;
for i = games
    P_current = P_current * P;
    Prob_of_A_ruin = [Prob_of_A_ruin, P_current(A_start+1, 1)];
    Prob_of_B_ruin = [Prob_of_B_ruin, P_current(A_start+1, end)];
    Prob_of_no_ruin = [Prob_of_no_ruin, 1 - P_current(A_start+1, 1) - P_current(A_start+1, end)];
end

figure(1)
plot(games, Prob_of_A_ruin)
xlim([1, Total_Game_No])
ylim([0, 1])
title('Probability of A ruin')

figure(2)
plot(games, Prob_of_B_ruin)
xlim([1, Total_Game_No])
ylim([0, 1])
title('Probability of B ruin')

figure(3)
plot(games, Prob_of_no_ruin)
xlim([1, Total_Game_No])
ylim([0, 1])
title('Probability of no ruin')

% Print probability of no ruin for the first 10 games
disp(['Probability of no ruin for the first 10 games:']);
for k = 1:10
    disp(['Game ' num2str(k) ': ' num2str(Prob_of_no_ruin(k))]);
end


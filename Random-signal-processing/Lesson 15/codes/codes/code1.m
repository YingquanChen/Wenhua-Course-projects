clear
clc

P = [0.7,0.2,0.1;0.3,0.5,0.2;0.2,0.4,0.4];

Total_Gen_No = 30;
% Vec_ini = [1,0,0];
Vec_ini = [0,0,1];

gens = 1:Total_Gen_No;
Vec_current = Vec_ini;
Vec_all = Vec_ini;
for i = gens
    Vec_current = Vec_current*P;
    Vec_all = [Vec_all; Vec_current];
end

gens = [0, gens];

figure(1)
plot(gens, Vec_all(:, 1), 'b'), grid on, hold on
plot(gens, Vec_all(:, 2), 'r'), grid on, hold on
plot(gens, Vec_all(:, 3), 'k'), grid on, hold on
xlim([0,Total_Gen_No])
ylim([0,1])
legend('class 1', 'class 2', 'class 2')
title('distributions')

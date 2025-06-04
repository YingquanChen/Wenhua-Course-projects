clc 
clear all 
close all 

% Microphone spacing
d = 0.085; % meters
% Speed of sound
c = 340; % m/s
% Sampling rate
N = 44100;
% Initialize array to store results
result_table = zeros(23, 2);
% Loop through all possible M values
for M = -11:11
    % Calculate arrival angle θ
    theta = asind(M * c / (N * d));
    
    % Store results
    result_table(M + 12, 1) = M;
    result_table(M + 12, 2) = theta;
end

% Generate result table
T = array2table(result_table, 'VariableNames', {'lag', 'DOA'});
disp(T);

clear
clc

% Transition probability matrix P
P = [0.6 0.4;
     0.2 0.8];

% Compute the eigenvectors and eigenvalues
[V, D] = eig(P');

% Find the eigenvector corresponding to eigenvalue 1
for i = 1:size(D, 1)
    if abs(D(i, i) - 1) < 1e-6
        eig_index = i;
        break;
    end
end

% Extract the eigenvector corresponding to eigenvalue 1
stationary_distribution = V(:, eig_index);

% Normalize the stationary distribution
stationary_distribution = stationary_distribution / sum(stationary_distribution);

% Display the stationary distribution
disp('Stationary distribution (Market shares):');
disp(['Shampoo A: ' num2str(stationary_distribution(1))]);
disp(['Shampoo B: ' num2str(stationary_distribution(2))]);

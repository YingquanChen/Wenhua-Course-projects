clear;
clc;
% the above two commands clear all the previous record in the Memory

N_trades = 100;                             % trade N times
N_persons = 30;                             % totally 40 persons
N_persons_pairs = round(N_persons/2);       % 20 groups
counterparty_list = ones(N_persons, 1);     % the counterparty list of all persons this time
Strategies_one_trade = zeros(N_persons, 1); % the strategy of all persons this time
Return_one_trade = zeros(N_persons, 1);     % the retrun of all persons this time
Return_total = zeros(N_persons, 1);         % the retrun of all persons after N_trades times

X_betray_trust_point = 6;
Y_betray_betray_point = 3;

for n_trade = 1 : N_trades                  % looping
    n_trade                                 % just to show the trade no for quick check
    Trade_target_pairs = randperm(N_persons)';      % make a permutation of all 40 persons, from ID 1 to 40 randomly
    %% decide the trade counterparties of this time
    [Trade_list,Trade_index] = sort(Trade_target_pairs);
    for person_id = 1:N_persons
        ranking = Trade_index(person_id);
        if mod(ranking,2)==0
            counterparty_ranking = ranking - 1;
        else
            counterparty_ranking = ranking + 1;
        end
        counterparty_list(person_id) = Trade_target_pairs(counterparty_ranking);
    end
    %% run the Strategies of all the persons
    % One can only get the ID of his counterparty as the input. 
    % However, when deciding your Strategy, you can store previous results
    % for your reference, I will give examples later.
    Strategies_one_trade = Run_Strategies(counterparty_list);
    %% evaluate the Strategies, and calculate the points all persons get
    for person_id = 1:N_persons
        Strategy_this = Strategies_one_trade(person_id);
        Strategy_counterparty = Strategies_one_trade(counterparty_list(person_id));
        if Strategy_this==0
            if Strategy_counterparty==0
                Return_one_trade(person_id) = 10;   % both trust, add 10 points
            elseif Strategy_counterparty>0
                Return_one_trade(person_id) = -X_betray_trust_point;   % self trust, counterparty betray, -X = -6 points
            else
                Return_one_trade(person_id) = 0;    % self trust, counterparty reject, 0 points
            end
        elseif Strategy_this>=0
            if Strategy_counterparty==0
                Return_one_trade(person_id) = 2*X_betray_trust_point;   % self betray, counterparty trust, + 2 * X = 12 points
            elseif Strategy_counterparty>0
                Return_one_trade(person_id) = -Y_betray_betray_point;    % self betray, counterparty betray, -Y = -0 points
            else
                Return_one_trade(person_id) = 0;    % self betray, counterparty reject, 0 points
            end
        else    % self reject, always 0 points, no matter what counterparty action is
            Return_one_trade(person_id) = 0;
        end
    end
    Return_total = Return_total + Return_one_trade; % update the return of all persons
    %% 
    % here you will be given your counterparty id and his behaviour
    % information of this time for your future references
    for person_id=1:N_persons
        filename=['infor_id',num2str(person_id)];
%         eval([filename,'=person_id']);
        counterparty_id = counterparty_list(person_id);
        counterparty_action = Strategies_one_trade(counterparty_id);
        save(filename, 'counterparty_id', 'counterparty_action');
    end
end

bar(Return_total)
xlim([0,31])
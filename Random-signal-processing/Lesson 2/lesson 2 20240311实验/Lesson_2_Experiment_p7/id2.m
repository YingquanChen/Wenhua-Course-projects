% Print your student ID and Name here, for example
% 2022090123    徐雷
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id2(counterparty_id)
    load storage_id2.mat
    
    % Check if the current trade number is a multiple of 3
    if mod(Trade_no, 3) == 0
        your_strategy = 1;  % Betray the counterparty
    else
        your_strategy = 0;  % Trust the counterparty
    end
    
    Trade_no = Trade_no + 1;
    save('storage_id2', 'Trade_no', 'your_id')
    
end

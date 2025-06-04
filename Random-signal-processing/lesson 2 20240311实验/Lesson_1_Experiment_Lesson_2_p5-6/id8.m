% Print your student ID and Name here, for example
% 2022280142    Yinlin Cui
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id8(counterparty_id)
    load infor_id8.mat
    load storage_id8.mat
    randNum = rand;                                     % generate a random number to signify trust rate                 
    if mod(counterparty_action,2) == 1 && randNum >= 0.05  % rand means rate of trust again to reduce misunderstanding
        your_strategy = 1;                              % this means that you will betray this person
    else
        your_strategy = 0;                              % this means that you will trust this person
    end
    Trade_no = Trade_no + 1;                            % update trade times
    save('storage_id8', 'Trade_no', 'your_id')
end



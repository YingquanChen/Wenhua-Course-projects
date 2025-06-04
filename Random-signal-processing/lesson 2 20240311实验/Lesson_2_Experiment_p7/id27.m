% Print your student ID and Name here, for example
% 2022280573   Ziwei Wang 王梓为
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
%% Now we begins
function [your_strategy] = id27(counterparty_id)
    load storage_id27.mat
    load infor_id27.mat
    % Using tit for tat strategy
    if counterparty_action == 0
        your_strategy = 0;  % this means that you will trust this person
    else
        num = rand() * 100;
        if num <= 70
            your_strategy = 1;  % this means that you will betray this person
        else 
            your_strategy = 0;  % this means that you will trust this person
    end
    Trade_no = Trade_no + 1;
    save('storage_id27', 'Trade_no', 'your_id')
   
end
% Print your student ID and Name here, for example
% 2022280069    曾颖岚
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id6(counterparty_id)
    load infor_id6.mat;
    load storage_id6.mat;
    your_strategy = 1;  % this strategy means that you will always betray anyone
    Trade_no = Trade_no + 1;
    save('storage_id6', 'Trade_no', 'your_id');
end
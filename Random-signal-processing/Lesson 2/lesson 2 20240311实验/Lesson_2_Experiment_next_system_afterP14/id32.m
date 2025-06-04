% Print your student ID and Name here, for example
% 000000    Weize Sun
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id32(counterparty_id)
    your_strategy = 1;  % this strategy means that you will always betray anyone 
end
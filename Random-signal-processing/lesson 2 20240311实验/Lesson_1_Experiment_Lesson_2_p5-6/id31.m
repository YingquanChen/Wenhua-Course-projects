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
function [your_strategy] = id31(counterparty_id)
    load infor_id31.mat
    if counterparty_action == 0
        your_strategy = 0;  % this means that you will trust this person
    else
        your_strategy = 1;  % this means that you will betray this person
    end
    % This person's strategy is: 
    % if get trusted last time, trust this person
    % if not, betray this person
end
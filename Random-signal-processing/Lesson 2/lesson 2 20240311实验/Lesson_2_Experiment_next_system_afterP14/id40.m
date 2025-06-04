% Print your student ID and Name here, for example
% 000000    Weize Sun
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy > 0 means that you want to betray the counterparty this time 
% your_strategy = others means that you reject this counterparty
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id40(counterparty_id)
    counterparty_now = counterparty_id;     
    % as loading the infor_id40.mat will give a variable named
    % counterparty_id, therefore here, we store the counterparty_id from
    % the input to counterparty_now first! 
    % In fact, this problem can be solved by a good design of the system,
    % you can modify the system by yourself, however, when submitting your
    % homework, your are suggestted to use this commend!
    load infor_id40.mat
    load storage_id40.mat
    if Trade_no==0
        list_betray = [];
    end
    if counterparty_action > 0
        list_betray = [list_betray; counterparty_id];
    end
    [m]=find(list_betray==counterparty_now);
    % if m is 'empty 0*0 double', then the counterparty_now had not been
    % betrayed you; otherwise, the counterparty_now had betrayed you at
    % least once
    if isempty(m)
        your_strategy = 0;      % if not been betrayed before, trade with this person
    else
        your_strategy = -1;     % otherwise, reject to trade
    end
    Trade_no = Trade_no + 1;
    save storage_id40.mat Trade_no your_id list_betray    
end
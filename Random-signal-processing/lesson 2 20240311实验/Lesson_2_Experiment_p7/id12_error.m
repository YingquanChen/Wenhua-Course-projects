% Print your student ID and Name here, for example
% 2021280224    蓝妙芳
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id12(counterparty_id)
    load infor_id12.mat
    load storage_id12.mat
    if counterparty_action == 0
        Trust_no = Trust_no + 1;  % count the total number you've been trusted
    else
        Betray_no = Betray_no + 1;  % count the total number you've been betrayed
    end
    save('storage_id12', 'Trust_no', 'Betray_no')
    if Trust_no > Betray_no
        your_strategy = 0;  % this means that you will trust this person
    else
        your_strategy = 1;  % this means that you will betray this person
    end
end
% you will trust a person if you have been trusted more than betrayed
% before, and vice versa
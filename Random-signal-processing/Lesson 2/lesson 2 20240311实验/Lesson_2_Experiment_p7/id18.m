% Print your student ID and Name here, for example
% 2022280419    Yulong Xue
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id18(counterparty_id)
    load infor_id18.mat counterparty_action;
    load storage_id18.mat Trade_no your_id;
    if Trade_no<=2
        your_strategy = 0;  % this strategy means that you will trust anyone if he doesn't betray you for more than 2 times
    else
        if counterparty_action==0
            your_strategy=round(rand(0,1));
        else
            your_strategy=round(rand(0.25,1));
        end
    end
    save('storage_id18.mat','Trade_no','your_id');

end
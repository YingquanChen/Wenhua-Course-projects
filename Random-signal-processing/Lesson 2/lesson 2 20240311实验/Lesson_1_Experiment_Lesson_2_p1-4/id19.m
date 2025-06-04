% Print your student ID and Name here, for example
% 2022280432    Jia Peng
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id19(counterparty_id)
    load infor_id19.mat
    load storage_id19.mat

    if counterparty_action == 1
        prob = 0.6;
        your_strategy = rand() <= prob; %this means that if you were betrayed by counterparty last time
                                        %you will have a 60 percent chance of betraying counterparty.
    else
        your_strategy = 0; %this means that if you were trusted by counterparty last time
                           %you will trust counterparty this time.
    end
    Trade_no = Trade_no + 1;
    save('storage_id19.mat', 'Trade_no', 'your_id');
end
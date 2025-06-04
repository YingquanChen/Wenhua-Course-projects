% Print your student ID and Name here, for example
% 2022280247    Yinyin Lin
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
%%
function [your_strategy] = id12(counterparty_id)
    load infor_id12.mat;
    load storage_id12.mat;
    
    if counterparty_action==0
        your_strategy=round(rand); %this means that you will have a 50% probability to trust this time
    else
        your_strategy=randi([0, 9]);
        if your_strategy<3
            your_strategy=0; %this means that you will have a 75% probability to betray this time
        end
    end
    Trade_no = Trade_no + 1;
    save('storage_id12','Trade_no','your_id');
    %if last time you are trusted, you will have a 50% probability to trust this time
    %if you are betrayed last time, you will have a 75% probability to betray this time
end
% Print your student ID and Name here, for example
% 2022280453    陈奇峰
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
%% Now we begins
function [your_strategy] = id22(counterparty_id)
    load storage_id22.mat
    load infor_id22.mat

    if counterparty_action == 1
        if randi([0,1]) == 1
            your_strategy = 0; % This means that you have 50% probability to trust this person
        else
            your_strategy = 1; % This means that you have 50% probability to betray this person
        end
    else
        your_strategy = 0;% This means that you will trust this person
    end

    Trade_no = Trade_no + 1;
    save('storage_id22', 'Trade_no', 'your_id')
    % your strategy will trush one person and then betray one and goes on
    % ONLY save your data in the file storage_id22.mat, 
    % otherwise you will be treated as 'homework not submitted'
end
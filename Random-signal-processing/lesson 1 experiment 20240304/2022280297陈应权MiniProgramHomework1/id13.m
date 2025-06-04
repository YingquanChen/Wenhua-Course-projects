% Print your student ID and Name here, for example
% 2022280297    陈应权
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id13(counterparty_id)
    load infor_id13.mat
    if counterparty_action==0
        your_strategy=0; % this means that you will trust this person
    else
        random_num=unifrnd(0,1);
        if random_num>0.5
            your_strategy=0; % this means that you will trust this person
        else
            your_strategy=1;   % this means that you will betray this person
        end
    end
    % This person's strategy is: 
    % if get trusted last time, trust this person
    % if not,he will flip a coin,if it's positive, continue to trust this person
    %if not,he will betray this person
end

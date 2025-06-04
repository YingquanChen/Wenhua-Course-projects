% Print your student ID and Name here, for example
% 2022280162    Yuanyuan Zeng
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id10(counterparty_id)
    your_strategy = 0;  % this strategy means that you will always trust anyone 
    load storage_id10.mat;
    load infor_id10.mat;
    if counterparty_action == 0 
        your_strategy = 0;  % this means that if you betray this partner,you're probably going to get 2x amount of revenue
    else
        x=rand(1);
        if x>=0.8
        your_strategy = 1;  % There's a 20 percent chance you'll betray this partner
        else 
        your_strategy=0;% There's a 80 percent chance you'll trust this partner
        end
    end
end
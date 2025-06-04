% Print your student ID and Name here, for example
% 2022280574    马海洲
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
%% Now we begins
function [your_strategy] = id28(counterparty_id)
    load infor_id28.mat    
    load storage_id28.mat

    your_strategy = 0;  % this means that you will trust this person all the time
    Trade_no = Trade_no + 1;
    save('storage_id28', 'Trade_no', 'your_id')
    % your strategy will trust this person all the time
    % ONLY save your data in the file storage_id28.mat, 
    % otherwise you will be treated as 'homework not submitted'
end
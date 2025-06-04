% Print your student ID and Name here, for example
% 2022280485    Sujian Jia
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
%% Now we begins
function [your_strategy] = id23(counterparty_id)
    load storage_id23.mat

    your_strategy = 0;  % this strategy means that you will always trust anyone 

    Trade_no = Trade_no + 1;
    save('storage_id21', 'Trade_no', 'your_id')
    % your strategy will trush one person and then betray one and goes on
    % ONLY save your data in the file storage_id23.mat, 
    % otherwise you will be treated as 'homework not submitted'
end
% Print your student ID and Name here, for example
% 2022280160    Yuming Yao
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id9(counterparty_id)
    % Load storage data and information data
    load storage_id9.mat Trade_no your_id;
    load infor_id9.mat counterparty_action;

    % Update Trade_no based on the counterparty's trading action
    if counterparty_action == 0
        Trade_no = Trade_no + 1; % Increase Trade_no when the counterparty performs a buy action
    else 
        Trade_no = Trade_no - 1; % Decrease Trade_no when the counterparty performs a sell action
    end

    % Save the updated Trade_no and your_id to the storage file
    save('storage_id9.mat', 'Trade_no', 'your_id');

    % Determine the trading strategy for your side based on the value of Trade_no
    if Trade_no >= 0
        your_strategy = round(rand); % Choose strategy 0 when Trade_no is greater than or equal to 0
    else 
        your_strategy = round(0.25+rand); % Choose strategy 1 when Trade_no is less than 0
    end

    %All in all,This strategy is get the counterparty_action
    %And record it into the Trade_no
    %Finally we decide our strategy through the value of Trade_no
end

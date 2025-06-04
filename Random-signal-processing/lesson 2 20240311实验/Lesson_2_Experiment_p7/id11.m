% 2022280179    Ziqi Li
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id11(counterparty_id)
    %your_strategy = 1;  % this strategy means that you will always betray anyone 
    ra = randi(9);
    remainder = rem(ra, 2);
    % Generate a number randomly and determine if it's odd or even
    if remainder == 1
        your_strategy = 0;
    else 
        your_strategy = 1;
    end
    % This person's strategy is: Trust the counterparty randomly.
    % If the random number is odd choose to trust and the even means betray
    
end
clear;
clc;
warning off
independent_run = 200;
independent_run_list = [];

refuse_trade_directly=0;

for independent_run = 1:independent_run
    % the probability of the counterparty's betrayal is uniform distributed between 0.4 and 0.8
    counterparty_betray_prob = 0.4 + (0.8 - 0.4) * rand(1);
    
    % Determine the counterparty's actions
    friends_betrayals = sum(rand(100, 100) < counterparty_betray_prob , 2) ;
    
    % Obtain counterparty's action
    counterparty_action = counterparty_betray_prob > rand(1);
    
    % Obtain own action
    Your_Strategy = strategy_extra(friends_betrayals);
    
    % Not exceeding the probability threshold, you can try trading
    if Your_Strategy == 0
        if counterparty_action == 0
            current = 10; % Mutual trust , increases transaction returns by 10 points
        else
            current = -5; % you trust，counterparty betray，decreases transaction returns by 5 points
        end
    
    else
        current = 0; % you reject，transaction returns remain unchanged
    end
    
    independent_run_list(end+1) = current; % record the total return on each independent run
end

total_return = sum(independent_run_list); % Total revenue


% Calculate the number of times the return is -5, 0, and 10
num_minus_5 = length(find(independent_run_list==-5));
num_0 =length(find(independent_run_list==0));
num_10 =length(find(independent_run_list==10));

% randomly selected profit
comparenumber = 200*0.5*0 + 200*0.5*0.4*10 + 200*0.5*0.6*(-5);  

% If the total profit is greater than the randomly selected profit and the number of times the return is 10 is more than the return is -5, it indicates success; Otherwise, failure
if total_return > comparenumber && num_10 > num_minus_5
    disp("success")
else
    disp("fail")
end

% Calculate the total revenue from 200 independent runs
fprintf('total_return：%d\n', sum(total_return));

% Draw a pie chart. View the proportion of returns of -5, 0, and 10
figure;
x = [num_minus_5,num_0,num_10];
p = pie(x);
pText = findobj(p,'Type','text');
percentValues = get(pText,'String'); 
txt = {'Revenue is -5: ';'Revenue is 0: ';'Revenue is 10: '}; 
combinedtxt = strcat(txt,percentValues); 
pText(1).String = combinedtxt(1);
pText(2).String = combinedtxt(2);
pText(3).String = combinedtxt(3);


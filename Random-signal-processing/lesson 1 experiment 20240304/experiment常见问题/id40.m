% Print your student ID and Name here, for example
% 没有写学号    没有写姓名
%%
% your_strategy returns your strategy of the trade this time
% your_strategy = 0 means that you want to trust the counterparty this time
% your_strategy not equal to 0 means that you want to betray the
% counterparty this time 
%%
% counterparty_id is the ID of the counterparty you are going to trade with
% this time
function [your_strategy] = id40(counterparty_id)
    load infor_id40
    load storage_id40
    save('storage_id40', 'XXX', 'XXX')  % 无法运行
    your_strategy = round(rand(1),0);  
    % this strategy means that you will always betray anyone 
    % 不合理的注释
end


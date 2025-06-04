function Your_Strategy = Your_Strategies(counterparty_previous_action)
    % Estimate betray rate based on previous actions
    betray_rate = (sum(counterparty_previous_action)+1) / (10+2); %According to what we have learned and Bayes' theorem, we can predict the probability of the opponent's betrayal
    
    % Make decision based on estimated betray rate
    if betray_rate > 0.6
        % If betray rate is greater than 0.5, reject the trade
        Your_Strategy = 1;  % Reject
    else
        % If betray rate is less than or equal to 0.5, trust the counterparty
        Your_Strategy = 0;  % Trust
    end
end

function Your_Strategy = strategy_extra(friends_betrayals)
    % Create a 100 x 100 zero matrix
    counterparty_betray_list = zeros(100 * 100, 1);
    
    % Traverse the original list and expand each element into a list with a distribution of 01
    for i = 1:100
        % Get the number of event occurrences for the current element in the original list
        event_count = friends_betrayals(i);
        
        % Calculate the starting index of the current element in the expanded list
        start_index = (i - 1) * 100 + 1;
        
        % Set the corresponding element in the expanded list to 1 (indicating the occurrence of an event)
        counterparty_betray_list(start_index:start_index+event_count-1) = 1;
    end
    
    % Using binofit to estimate the parameter p_hat of a binomial distribution
    [p_hat, ~] = binofit(sum(counterparty_betray_list), numel(counterparty_betray_list));
    
    % Set upper and lower limits for uniform distribution
    a = 0.4;   
    b = 0.8;   
    
    % Generate x vector
    x = linspace(a, b, 1000);  
    
    % Generate a prior probability density function for a uniform distribution
    prior_pdf = unifpdf(x, a, b);  
    
    % Calculate PDF based on the uniform distribution and binomial distribution
    posterior_pdf = prior_pdf .* binopdf(round(x*numel(counterparty_betray_list)), numel(counterparty_betray_list), p_hat);  
    
    % Normalize the posterior probability density function
    posterior_pdf = posterior_pdf ./ trapz(x, posterior_pdf); 
    
    %Calculate expectations and estimate the probability of betrayal
    counterparty_betray_prob_infer = trapz(x, x .* posterior_pdf); 
    
    % Set the threshold to 2/3 , because when p>2/3 , E{refuse} > E{trade}
    if counterparty_betray_prob_infer < 2/3
        % try to trade,trust or distrust will be randomly determined based on probability
        Your_Strategy = 0; 
    else
        % otherwise , reject the transaction directly
        Your_Strategy = 1;  
    end
end

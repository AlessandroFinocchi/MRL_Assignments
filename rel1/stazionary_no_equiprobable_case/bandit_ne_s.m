function r = bandit_ne_s(agent_int)
agent_int = agent_int - 1;
% stationary no-equiprobable case (normal distribution)
action_space = 0:4;
prob = [0.1, 0.1, 0.1, 0.1, 0.6];
bandit_int = randsample(action_space, 1, true, prob);
    if bandit_int == mod(agent_int + 2, 5) || bandit_int == mod(agent_int + 4, 5)
        r = 1;
    elseif bandit_int == mod(agent_int + 1, 5) || bandit_int == mod(agent_int + 3, 5)
        r = -1;
    else 
        r = 0;
    end 
end
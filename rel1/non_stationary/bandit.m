function [r] = bandit(agent_int, episodes, current_episode)
% non stationary case 

action_space = 0:4;
agent_int = agent_int-1;

% Rock probability varies from 0,1 to 0,6 linearly
% Lizard probability varies from 0,6 to 0,1 linearly
% Other probabilities are constant
c = current_episode/episodes;
prob = [0.1 + c * 0.5, 0.1, 0.1, 0.1, 0.6 - c * 0.5];

% Bandit chooses an action with probabilities like in prob
bandit_int = randsample(action_space, 1, true, prob);

    if bandit_int == mod(agent_int + 2, 5) || bandit_int == mod(agent_int + 4, 5)
        r = 1;
    elseif bandit_int == mod(agent_int + 1, 5) || bandit_int == mod(agent_int + 3, 5)
        r = -1;
    else 
        r = 0;
    end

end
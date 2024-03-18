function [r1, r2] = bandit_fight(agent1_int, agent2_int)

agent1_int = agent1_int - 1;
agent2_int = agent2_int - 1;
    
if agent2_int == mod(agent1_int + 2, 5) || agent2_int == mod(agent1_int + 4, 5)
        r1 = 1;
        r2 = -1;
    elseif agent2_int == mod(agent1_int + 1, 5) || agent2_int == mod(agent1_int + 3, 5)
        r1 = -1;
        r2 = 1;
    else 
        % r1 = 0;
        r1 = -0.5;
        % r2 = 0;
        r2 = -0.5;
end

end
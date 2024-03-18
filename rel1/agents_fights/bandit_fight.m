function [r1, r2] = bandit_fight(agent1_int, agent2_int)

agent1_int = agent1_int - 1;
agent2_int = agent2_int - 1;
    
if agent2_int == mod(agent1_int + 2, 3)
        r1 = 1;
        r2 = -1;
    elseif agent2_int == mod(agent1_int + 1, 3)
        r1 = -1;
        r2 = 1;
    else 
        r1 = 0;
        r2 = 0;
end

end
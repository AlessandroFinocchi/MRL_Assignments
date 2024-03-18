function [q,r] = bandit(q,agent_int)
% non stationary case 

bandit_int = randi(5) - 1;

i1 = mod(bandit_int + 2, 5) + 1;
i2 = mod(bandit_int + 4, 5) + 1;
i3 = mod(bandit_int + 1, 5) + 1;
i4 = mod(bandit_int + 3, 5) + 1;

% Update q with the bandit draw
q(i1) = q(i1) + 1;
q(i2) = q(i2) + 1;
q(i3) = q(i3) - 1;
q(i4) = q(i4) - 1;

r = q(agent_int) + randn;

end


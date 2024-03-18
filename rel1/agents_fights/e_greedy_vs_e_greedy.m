clear
close all
clc

rng(42) % set the random seed

A = 3; % dimension action space
epsilon = 0.2; % probability we take a random action
lengthEpisode = 20000; % number of actions to take
alpha = 1e-3;

Q1 = ones(A, 1); % estimate of the value of actions for agent 1
N1 = zeros(A, 1); % number of times we take each action for agent 1

Q2 = ones(A, 1); % estimate of the value of actions for agent 2
N2 = zeros(A, 1); % number of times we take each action for agent 2

% save history of Q and N
historyQ1 = zeros(A, lengthEpisode);
historyN1 = zeros(A, lengthEpisode);
historyQ2 = zeros(A, lengthEpisode);
historyN2 = zeros(A, lengthEpisode);

v = 0;
V1 = 0;
V2 = 0;

for i = 1:lengthEpisode

    % Agent 1 chooses action
    if rand < epsilon
        % we take a random action
        agent1_int = randi(A); 
    else
        % we take the greedy action
        agent1_int = find(Q1 == max(Q1));
        agent1_int = agent1_int(randi(length(agent1_int))); % parity broken by random
    end

     % Agent 2 chooses action
    if rand < epsilon
        % we take a random action
        agent2_int = randi(A); 
    else
        % we take the greedy action
        agent2_int = find(Q2 == max(Q2));
        agent2_int = agent2_int(randi(length(agent2_int))); % parity broken by random
    end

    [r1, r2] = bandit_fight(agent1_int, agent2_int); % compute reward

    if i == 1
        if r1 == 1
            v = 1;
        elseif r1 == -1
            v = 2;
        end
    end

    if r1 == 1
        V1 = V1 + 1;
    elseif r1 == -1
        V2 = V2 + 1;
    end

    % update N and Q
    N1(agent1_int) = N1(agent1_int) + 1;
    Q1(agent1_int) = Q1(agent1_int) + 1/N1(agent1_int)*(r1 - Q1(agent1_int));
    % Q1(agent1_int) = Q1(agent1_int) + alpha*(r1 - Q1(agent1_int));

    N2(agent2_int) = N2(agent2_int) + 1;
    Q2(agent2_int) = Q2(agent2_int) + 1/N2(agent2_int)*(r2 - Q2(agent2_int));
    % Q2(agent2_int) = Q2(agent2_int) + alpha*(r2 - Q2(agent2_int));


    % save the history
    historyQ1(:,i) = Q1;
    historyN1(:, i) = N1;
    historyQ2(:,i) = Q2;
    historyN2(:, i) = N2;
end

%% plots


% plot the history of N
figure()
plot([historyQ1', historyQ2'], 'LineWidth', 2)
legend('Rock1', 'Paper1', 'Scissors1', 'Rock2', 'Paper2', 'Scissors2')
title('DIO')

v
V1
V2

% convergence of Q for number of episodes tending to infinity
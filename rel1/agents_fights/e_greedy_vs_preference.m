clear
close all
clc

rng(45) % set the random seed

%-----------Common initializzation-----------------------------------
A = 5; % dimension action space
alpha = 1e-2; % update step for preferences
beta = 1e-1; % update step for rewards
lengthEpisode = 20000; % number of actions to take
historyW = zeros(3, lengthEpisode); % history of match result
W = [0,0,0]; % counter for [agent 1 win, agent 2 win, draws]


%-------Initializzation for the first agent--------------------------
Q1 = zeros(A, 1); % estimate of the value of actions for agent 1
N1 = zeros(A, 1); % number of times we take each action for agent 1
epsilon = 0.05;
historyQ1 = zeros(A, lengthEpisode);
historyN1 = zeros(A, lengthEpisode); 


%-------Initializzation for the second agent--------------------------
H2 = zeros(A, 1); % preferences of actions
avg_r2 = 0; % initialization of average reward 
historyH2 = zeros(A, lengthEpisode); % save history of H


for i = 1:lengthEpisode

    %--------------------First agent work----------------------------   
    if rand < epsilon
        agent_int1 = randi(A); % we take a random action
    else
        agent_int1 = find(Q1 == max(Q1), 1, 'first'); % we take the greedy action
    end

    %--------------------Second agent work----------------------------   
    Proba2 = exp(H2)/sum(exp(H2)); % Compute softmax for each action
    csProba2 = cumsum(Proba2); %choose action based on softmax
    agent_int2 = find(rand < csProba2, 1, "first");

    % Compute reward for the two agent
    [r1, r2] = bandit_fight(agent_int1, agent_int2); 

    %-------------Update N and Q for the first agent-----------------
    N1(agent_int1) = N1(agent_int1) + 1;
    Q1(agent_int1) = Q1(agent_int1) + alpha*(r1 - Q1(agent_int1));

    %-------------Update preferences for the second agent-----------------
    H2(agent_int2) = H2(agent_int2) + alpha*(r2 - avg_r2)*(1-Proba2(agent_int2)); 
    % update not-taken actions preferences
    notagent_int2 = 1:A;
    notagent_int2(agent_int2) = [];
    H2(notagent_int2) = H2(notagent_int2) - alpha*(r2 - avg_r2)*Proba2(notagent_int2);
    avg_r2 = avg_r2 + beta*(r2-avg_r2); % update average reward with fixed step

    %----------Update first agent history----------------------
    historyQ1(:,i) = Q1;
    historyN1(:,i) = N1;

    %----------Update second agent history---------------------
    historyH2(:,i) = H2;

    % ---------Update match result history---------------------
    if r1 == 1
        W = W + [1, 0, 0];
    elseif r1 == -1
        W = W + [0, 1, 0];
    else
        W = W + [0, 0, 1];
    end
    historyW(:,i) = W;
    %-------------------------------------------------
end

%% plots

figure()
hold on
plot(historyW(1,:)', 'LineWidth', 2)
plot(historyW(2,:)', 'LineWidth', 2, 'LineStyle','--')
plot(historyW(3,:)', 'LineWidth', 2, 'LineStyle',':')
hold off
legend('W_1', 'W_2', 'W_D')
title('W')


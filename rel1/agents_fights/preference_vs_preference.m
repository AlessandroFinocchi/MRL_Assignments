clear
close all
clc

rng(45) % set the random seed

%-----------Common initializzation-----------------------------------
A = 5; % dimension action space
alpha = 1e-2; % update step for preferences
beta = 1e-1; % update step for rewards
lengthEpisode = 20000; % number of actions to take
%--------------------------------------------------------------------

%-------Initializzation for the first agent--------------------------
H1 = zeros(A, 1); % preferences of actions
avg_r1 = 0; % initialization of average reward 
historyH1 = zeros(A, lengthEpisode); % save history of H
%--------------------------------------------------------------------

%-------Initializzation for the second agent--------------------------
H2 = zeros(A, 1); % preferences of actions
avg_r2 = 0; % initialization of average reward 
historyH2 = zeros(A, lengthEpisode); % save history of H
%---------------------------------------------------------------------

for i = 1:lengthEpisode

    %--------------------First agent work----------------------------   
    Proba1 = exp(H1)/sum(exp(H1)); % Compute softmax for each action
    csProba1 = cumsum(Proba1); %choose action based on softmax
    agent_int1 = find(rand < csProba1, 1, "first");
    %----------------------------------------------------------------

    %--------------------Second agent work----------------------------   
    Proba2 = exp(H2)/sum(exp(H2)); % Compute softmax for each action
    csProba2 = cumsum(Proba2); %choose action based on softmax
    agent_int2 = find(rand < csProba2, 1, "first");
    %----------------------------------------------------------------

    %Compute reward for the two agent
    [r1, r2] = bandit_fight(agent_int1, agent_int2); 

    %-------------Update preferences for the first agent-----------------
    H1(agent_int1) = H1(agent_int1) + alpha*(r1 - avg_r1)*(1-Proba1(agent_int1)); 
    % update not-taken actions preferences
    notagent_int1 = 1:A;
    notagent_int1(agent_int1) = [];
    H1(notagent_int1) = H1(notagent_int1) - alpha*(r1 - avg_r1)*Proba1(notagent_int1);
    avg_r1 = avg_r1 + beta*(r1-avg_r1); % update average reward with fixed step

    % save the history for the first agent
    historyH1(:,i) = H1;

    %-------------Update preferences for the second agent-----------------
    H2(agent_int2) = H2(agent_int2) + alpha*(r2 - avg_r2)*(1-Proba2(agent_int2)); 
    % update not-taken actions preferences
    notagent_int2 = 1:A;
    notagent_int2(agent_int2) = [];
    H2(notagent_int2) = H2(notagent_int2) - alpha*(r2 - avg_r2)*Proba2(notagent_int2);
    avg_r2 = avg_r2 + beta*(r2-avg_r2); % update average reward with fixed step

    % save the history for the first agent
    historyH2(:,i) = H2;
end

%% plots

% plot the history of H1
figure()
plot(historyH1','LineWidth',2)
ylabel("H1")
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of H2
figure()
plot(historyH2','LineWidth',2)
ylabel("H2")
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')


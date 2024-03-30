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
H1 = zeros(A, 1); % preferences of actions
avg_r1 = 0; % initialization of average reward 
historyH1 = zeros(A, lengthEpisode); % save history of H

%-------Initializzation for the second agent--------------------------
H2 = zeros(A, 1); % preferences of actions
avg_r2 = 0; % initialization of average reward 
historyH2 = zeros(A, lengthEpisode); % save history of H

for i = 1:lengthEpisode

    %--------------------First agent work----------------------------   
    Proba1 = exp(H1)/sum(exp(H1)); % Compute softmax for each action
    csProba1 = cumsum(Proba1); %choose action based on softmax
    agent_int1 = find(rand < csProba1, 1, "first");
    

    %--------------------Second agent work----------------------------   
    Proba2 = exp(H2)/sum(exp(H2)); % Compute softmax for each action
    csProba2 = cumsum(Proba2); %choose action based on softmax
    agent_int2 = find(rand < csProba2, 1, "first");

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

    % save the history for the second agent
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

%-----------------plot the history of H1 e H2 -----------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('N')
plot(historyH1', 'LineWidth', 1.5)
plot(historyH2', 'LineWidth', 1.5, 'LineStyle','--')
lgn = legend('Rock_1', 'Paper_1', 'Scissors_1', 'Spock_1', 'Lizard_1', 'Rock_2', 'Paper_2', 'Scissors_2', 'Spock_2', 'Lizard_2');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/pref_vs_pref/H", "png")
%--------------------------------------------------------------------------

%-----------------plot the history of W------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('W')
plot(historyW(1,:)', 'LineWidth', 1.5)
plot(historyW(2,:)', 'LineWidth', 1.5, 'LineStyle','--')
plot(historyW(3,:)', 'LineWidth', 1.5, 'LineStyle',':')
lgn = legend('Wins_1', 'Wins_2', 'Draws');
set(gca, 'ColorOrder', colors(3))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save
saveas(gcf, "graphs/pref_vs_pref/W", "png")
%--------------------------------------------------------------------------


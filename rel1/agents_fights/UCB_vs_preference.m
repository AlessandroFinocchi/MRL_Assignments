clear
close all
clc

rng(42) % set the random seed

%-----------------Common initilization-----------------------------
A = 5; % dimension action space
lengthEpisode = 1e3; % number of actions to take
historyW = zeros(3, lengthEpisode); % history of match result
W = [0,0,0]; % counter for [agent 1 win, agent 2 win, draws]


%-------------Initialization for the UCB agent---------------------
c1 = 10; % exploration rate
alpha1 = 5e-2; % step size
Q1 = ones(A, 1); % estimate of the value of actions
N1 = zeros(A, 1); % number of times we take each action
historyQ1 = zeros(A, lengthEpisode); % save history of Q
historyN1 = zeros(A, lengthEpisode); % save history of N

%----------Initialization for the preference update agent----------
alpha2 = 4e-5; % update step for preferences
beta2 = 1e-2; % update step for rewards
H2 = zeros(A, 1); % preferences of actions
N2 = zeros(A, 1); % number of times we take each action
avg_r2 = 0; % initialization of average reward 
historyH2 = zeros(A, lengthEpisode); % save history of H
historyN2 = zeros(A, lengthEpisode); % save history of N

for i = 1:lengthEpisode
    
    %-----------------------UCB agent work-------------------------
    Qext1 = Q1 + c1*sqrt(log(i)./(N1+1)); % extended value function
    % we choose the action that maximized the Qext
    agent_int1 = find(Qext1 == max(Qext1)); 
    agent_int1 = agent_int1(randi(length(agent_int1))); % parity broken by random
    
    %----------------Preference update agent work------------------  
    Proba2 = exp(H2)/sum(exp(H2)); % Compute softmax for each action
    csProba2 = cumsum(Proba2); %choose action based on softmax
    agent_int2 = find(rand < csProba2, 1, "first");

    [r1, r2] = bandit_fight(agent_int1, agent_int2); % compute reward

    %---------------update N and Q for the UCB agent---------------------
    N1(agent_int1) = N1(agent_int1) + 1;
    Q1(agent_int1) = Q1(agent_int1) + 1/N1(agent_int1)*(r1 - Q1(agent_int1));

   
    %---------Update preferences for the preference update agent---------
    H2(agent_int2) = H2(agent_int2) + alpha2*(r2 - avg_r2)*(1-Proba2(agent_int2)); 
    N2(agent_int2) = N2(agent_int2) + 1;
    % update not-taken actions preferences
    notagent_int2 = 1:A;
    notagent_int2(agent_int2) = [];
    H2(notagent_int2) = H2(notagent_int2) - alpha2*(r2 - avg_r2)*Proba2(notagent_int2);
    avg_r2 = avg_r2 + beta2*(r2-avg_r2); % update average reward with fixed step

    %----------------save the history for the UCB agent-----------------
    historyQ1(:, i) = Q1;
    historyN1(:, i) = N1;

    %---------save the history for the preference update agent----------
    historyH2(:,i) = H2;
    historyN2(:,i) = N2;
    
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
figure;

figure('Position', [0, 50, , ]); % Impostare la posizione e le dimensioni della finestra [x, y, larghezza, altezza]




%-----------------plot the history of N------------------------------------
% Fixed
figure('Position', [0 50 700 420])
hold on
% Graph content
title('N')
plot(historyN1', 'LineWidth', 1.5)
plot(historyN2', 'LineWidth', 1.5, 'LineStyle','--')
lgn = legend( ...
    'Rock_1', 'Paper_1', 'Scissors_1', 'Spock_1', 'Lizard_1', ...
    'Rock_2', 'Paper_2', 'Scissors_2', 'Spock_2', 'Lizard_2');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/UCB_vs_UCB/N", "png")
%--------------------------------------------------------------------------

%-----------------plot the history of Q------------------------------------
% Fixed
figure('Position', [700 50 700 420])
hold on
% Graph content
title('Q1')
plot(historyQ1', 'LineWidth', 1.5)
lgn = legend('Rock_1', 'Paper_1', 'Scissors_1', 'Spock_1', 'Lizard_1');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/UCB_vs_UCB/Q", "png")
%--------------------------------------------------------------------------

%-----------------------plot the history of H1-----------------------------
% Fixed
figure('Position', [0 550 700 420])
hold on
% Graph content
title('H2')
plot(historyH2', 'LineWidth', 1.5)
lgn = legend('Rock_1', 'Paper_1', 'Scissors_1', 'Spock_1', 'Lizard_1');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/pref_vs_pref/H", "png")

%-----------------plot the history of W------------------------------------
% Fixed
figure('Position', [700 550 700 420])
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
saveas(gcf, "graphs/UCB_vs_UCB/W", "png")
%--------------------------------------------------------------------------

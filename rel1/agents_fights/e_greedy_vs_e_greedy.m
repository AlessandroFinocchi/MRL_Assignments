clear
close all
clc

rng(42) % set the random seed

A = 5; % dimension action space
epsilon = 0.05; % probability we take a random action
lengthEpisode = 2.5e2; % number of actions to take
alpha = 0.0125;

Q1 = zeros(A, 1); % estimate of the value of actions for agent 1
N1 = zeros(A, 1); % number of times we take each action for agent 1

Q2 = zeros(A, 1); % estimate of the value of actions for agent 2
N2 = zeros(A, 1); % number of times we take each action for agent 2

B1 = 0; % best choice for agent 1
B2 = 0; % best choice for agent 2

% history of Q, N and B
historyQ1 = zeros(A, lengthEpisode); % for agent 1
historyN1 = zeros(A, lengthEpisode);
historyB1 = zeros(1, lengthEpisode);
historyQ2 = zeros(A, lengthEpisode); % for agent 2
historyN2 = zeros(A, lengthEpisode);
historyB2 = zeros(1, lengthEpisode);

historyW = zeros(3, lengthEpisode); % history of match result
W = [0,0,0]; % counter for [agent 1 win, agent 2 win, draws]

for i = 1:lengthEpisode

    % Agent 1 chooses action
    if rand < epsilon
        agent1_int = randi(A); % we take a random action
    else
        agent1_int = find(Q1 == max(Q1), 1, 'first'); % we take the greedy action
    end

     % Agent 2 chooses action
    if rand < epsilon
        agent2_int = randi(A); % we take a random action
    else
        agent2_int = find(Q2 == max(Q2), 1, 'first'); % we take the greedy action
    end

    % update B
    B1 = find(Q1 == max(Q1), 1, 'first');
    B2 = find(Q2 == max(Q2), 1, 'first');

    % compute reward
    [r1, r2] = bandit_fight(agent1_int, agent2_int); 

    % update N and Q
    N1(agent1_int) = N1(agent1_int) + 1;
    % Q1(agent1_int) = Q1(agent1_int) + 1/N1(agent1_int)*(r1 - Q1(agent1_int));
    Q1(agent1_int) = Q1(agent1_int) + alpha*(r1 - Q1(agent1_int));

    N2(agent2_int) = N2(agent2_int) + 1;
    % Q2(agent2_int) = Q2(agent2_int) + 1/N2(agent2_int)*(r2 - Q2(agent2_int));
    Q2(agent2_int) = Q2(agent2_int) + alpha*(r2 - Q2(agent2_int));

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

    % save the history
    historyQ1(: ,i) = Q1; % for agent 1
    historyN1(:, i) = N1;
    historyQ2(:, i) = Q2; % for agent 2
    historyN2(:, i) = N2;

end

%% Graphs

%-----------------plot the history of Q----------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('Q')
plot(historyQ1', 'LineWidth', 1.5)
plot(historyQ2', 'LineWidth', 1.5, 'LineStyle','--')
lgn = legend('Rock_1', 'Paper_1', 'Scissors_1', 'Spock_1', 'Lizard_1', 'Rock_2', 'Paper_2', 'Scissors_2', 'Spock_2', 'Lizard_2');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/e_vs_e/Q", "png")
%--------------------------------------------------------------------------

%-----------------plot the history of V------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('N')
plot(historyN1', 'LineWidth', 1.5)
plot(historyN2', 'LineWidth', 1.5, 'LineStyle','--')
lgn = legend('Rock_1', 'Paper_1', 'Scissors_1', 'Spock_1', 'Lizard_1', 'Rock_2', 'Paper_2', 'Scissors_2', 'Spock_2', 'Lizard_2');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/e_vs_e/N", "png")
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
saveas(gcf, "graphs/e_vs_e/W", "png")
%--------------------------------------------------------------------------

close all
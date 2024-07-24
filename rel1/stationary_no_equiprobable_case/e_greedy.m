clear all
close all
clc

rng(42) % set the random seed

A = 5; % dimension action space
epsilon = 0.1; % probability we take a random action
lengthEpisode = 20000; % number of actions to take

Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action
W = [0,0,0]; % counter for [agent 1 win, agent 2 win, draws]

% save history of Q, N, and W
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);
historyW = zeros(3, lengthEpisode);

for i = 1:lengthEpisode
    if rand < epsilon
        agent_int = randi(A); % we take a random action
    else
        % to break parity
        agent_int = find(Q==max(Q));
        agent_int = agent_int(randi(length(agent_int)));
    end
    r = bandit_ne_s(agent_int); 
    N(agent_int) = N(agent_int) + 1; % increment the counter for the actions taken
    Q(agent_int) = Q(agent_int) + 1/N(agent_int)*(r - Q(agent_int));

    % ---------Update match result history---------------------
    if r == 1
        W = W + [1, 0, 0];
    elseif r == -1
        W = W + [0, 1, 0];
    else
        W = W + [0, 0, 1];
    end

    % save the history
    historyQ(:,i) = Q;
    historyN(:, i) = N;
    historyW(:,i) = W;

end

%% plots

%-----------------plot the history of Q------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('Q')
plot(historyQ', 'LineWidth', 3)
lgn = legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard');
lgn.FontSize = 24;
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/e/Q", "png")
%--------------------------------------------------------------------------

%-----------------plot the history of V------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('N')
plot(historyN', 'LineWidth', 3)
lgn = legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard');
lgn.FontSize = 24;
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/e/N", "png")
%--------------------------------------------------------------------------

%-----------------plot the history of W------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('W')
plot(historyW(1,:)', 'LineWidth', 3)
plot(historyW(2,:)', 'LineWidth', 3, 'LineStyle','--')
plot(historyW(3,:)', 'LineWidth', 3, 'LineStyle',':')
lgn = legend('Wins_{agent}', 'Wins_{bandit}', 'Draws');
lgn.FontSize = 24;
set(gca, 'ColorOrder', colors(3))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save
saveas(gcf, "graphs/e/W", "png")

% convergence of Q for number of episodes tending to infinity
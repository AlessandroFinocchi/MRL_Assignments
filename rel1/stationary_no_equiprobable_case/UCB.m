clear all
close all
clc

rng(1) % set the random seed

A = 5; % dimension action space
c = 10; % exploration rate
lengthEpisode = 1000; % number of actions to take

Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action
W = [0,0,0]; % counter for [agent 1 win, agent 2 win, draws]

% save history of Q, N, and W
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);
historyW = zeros(3, lengthEpisode);

for i = 1:lengthEpisode
    Qext = Q + c*sqrt(log(i)./(N+1)); % extended value function
    a = find(Qext == max(Qext), 1, "first"); % to break parity
    r = bandit_ne_s(a); 
    N(a) = N(a) + 1; % increment the counter for the actions taken
    Q(a) = Q(a) + 1/N(a)*(r - Q(a));

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
plot(historyQ', 'LineWidth', 1.5)
lgn = legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/UCB/Q", "png")
%--------------------------------------------------------------------------

%-----------------plot the history of V------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('N')
plot(historyN', 'LineWidth', 1.5)
lgn = legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/UCB/N", "png")
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
lgn = legend('Wins_{agent}', 'Wins_{bandit}', 'Draws');
set(gca, 'ColorOrder', colors(3))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save
saveas(gcf, "graphs/UCB/W", "png")
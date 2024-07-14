clear
close all
clc

rng(422) % set the random seed

A = 5; % dimension action space
epsilon = 1e-1; % probability we take a random action
lengthEpisode = 20000; % number of actions to take

Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action

% save history of Q and N
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);

% ----------Setup match result history-----------------
historyW = zeros(3, lengthEpisode);     % history of match result
W = [0,0,0];                            % counter for [agent 1 win, agent 2 win, draws]

% -----------------------------------------------------
for i = 1:lengthEpisode

    if rand < epsilon
        % we take a random action
        agent_int = randi(A); 
    else
        % we take the greedy action
        agent_int = find(Q == max(Q));
        agent_int = agent_int(randi(length(agent_int))); % parity broken by random
    end

    r = bandit_s_ep(agent_int); % compute reward

    % ---------Update match result history---------------------
    if r == 1
        W = W + [1, 0, 0];
    elseif r == -1
        W = W + [0, 1, 0];
    else
        W = W + [0, 0, 1];
    end
    historyW(:,i) = W;
    %----------------------------------------------------------

    % update N and Q
    N(agent_int) = N(agent_int) + 1;
    Q(agent_int) = Q(agent_int) + 1/N(agent_int)*(r - Q(agent_int));

    % save the history
    historyQ(:,i) = Q;
    historyN(:, i) = N;
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
% Save
saveas(gcf, "graphs/e-greedy/Q", "png")
%--------------------------------------------------------------------------

%-----------------plot the history of N------------------------------------
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
% Save
saveas(gcf, "graphs/e-greedy/N", "png")
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
saveas(gcf, "graphs/e-greedy/W", "png")
%--------------------------------------------------------------------------

% close all

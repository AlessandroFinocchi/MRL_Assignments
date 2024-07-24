clear
close all
clc

rng(42) % set the random seed

A = 5; % dimension action space
alpha = 1e-2; % update step for preferences
beta = 1e-1; % update step for rewards
lengthEpisode = 20000; % number of actions to take

H = zeros(A, 1); % preferences of actions
avg_r = 0; % initialization of average reward

% save history of H
historyH = zeros(A, lengthEpisode);

% ----------Setup match result history-----------------
historyW = zeros(3, lengthEpisode);     % history of match result
W = [0,0,0];                            % counter for [agent 1 win, agent 2 win, draws]

% -----------------------------------------------------
for i = 1:lengthEpisode

    Proba = exp(H)/sum(exp(H)); % Compute softmax for each action

    % choose action based on softmax
    csProba = cumsum(Proba);
    agent_int = find(rand < csProba, 1, "first");

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
    % -----------------------------------------------------

    H(agent_int) = H(agent_int) + alpha*(r - avg_r)*(1-Proba(agent_int)); % update taken action preference

    % update not-taken actions preferences
    notagent_int = 1:A;
    notagent_int(agent_int) = [];
    H(notagent_int) = H(notagent_int) - alpha*(r - avg_r)*Proba(notagent_int);

    avg_r = avg_r + beta*(r-avg_r); % update average reward with fixed step

    % save the history
    historyH(:,i) = H;
end

%% plots

%-----------------plot the history of N------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('H')
plot(historyH', 'LineWidth', 3)
lgn = legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard');
lgn.FontSize = 24;
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save
saveas(gcf, "graphs/preference_updates/H", "png")
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
saveas(gcf, "graphs/preference_updates/W", "png")
%--------------------------------------------------------------------------

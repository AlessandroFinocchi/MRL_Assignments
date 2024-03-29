clear all
close all
clc

rng(1) % set the random seed

A = 5; % dimension action space
alpha = 1e-2; % update step for preferences
beta = 1e-1; % update step for rewards
lengthEpisode = 20000; % number of actions to take
W = [0,0,0]; % counter for [agent 1 win, agent 2 win, draws]

H = zeros(A, 1); % preferences of actions
avg_r = 0; % initialization of average reward

% save history of H and W
historyH = zeros(A, lengthEpisode);
historyW = zeros(3, lengthEpisode);

for i = 1:lengthEpisode
    Proba = exp(H)/sum(exp(H));
    csProba = cumsum(Proba);
    a = find(rand < csProba, 1, "first");
    r = bandit_ne_s(a); 
    H(a) = H(a) + alpha*(r - avg_r)*(1-Proba(a));
    nota = 1:A;
    nota(a) = [];
    H(nota) = H(nota) - alpha*(r - avg_r)*Proba(nota);
    avg_r = avg_r + beta*(r-avg_r); % constant step for averagin rewards

    % ---------Update match result history---------------------
    if r == 1
        W = W + [1, 0, 0];
    elseif r == -1
        W = W + [0, 1, 0];
    else
        W = W + [0, 0, 1];
    end

    % save the history for H and W
    historyH(:,i) = H;
    historyW(:,i) = W;

end

%% plots

%-----------------plot the history of Q------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('H')
plot(historyH', 'LineWidth', 1.5)
lgn = legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard');
set(gca, 'ColorOrder', colors(5))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save graph
saveas(gcf, "graphs/preference_update/Q", "png")
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
saveas(gcf, "graphs/preference_update/W", "png")
clear all
close all
clc

rng(1) % set the random seed

A = 5; % dimension action space
alpha = 1e-2; % update step for preferences
beta = 1e-1; % update step for rewards
lengthEpisode = 20000; % number of actions to take
WW = 0; % counter for wins
WS = 0; % counter for defeats
WD = 0; % counter for draws

H = zeros(A, 1); % preferences of actions
avg_r = 0; % initialization of average reward

% save history of H
historyH = zeros(A, lengthEpisode);

% save history for W
historyWW = zeros(1, lengthEpisode);
historyWS = zeros(1, lengthEpisode);
historyWD = zeros(1, lengthEpisode);

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

    % save the history
    historyH(:,i) = H;

    % update W
    if r == 1
        WW = WW +1;
    elseif r == -1
        WS = WS + 1;
    else
        WD = WD + 1;
    end

    % save the history for W 
    historyWW(:, i) = WW;
    historyWS(:, i) = WS;
    historyWD(:, i) = WD; % for draws
end

%% plots

% plot the history of H
figure()
plot(historyH','LineWidth',2)
ylabel('H')
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

figure()
hold on
plot(historyWW', 'LineWidth', 2)
plot(historyWS', 'LineWidth', 2, 'LineStyle','--')
plot(historyWD', 'LineWidth', 2, 'LineStyle',':')
hold off
legend('W_W', 'W_S', 'W_D')
title('W')
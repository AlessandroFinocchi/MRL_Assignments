clear all
close all
clc

rng(42) % set the random seed

A = 5; % dimension action space
epsilon = 0.1; % probability we take a random action
lengthEpisode = 20000; % number of actions to take

Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action

WW = 0; % counter for wins
WS = 0; % counter for defeats
WD = 0; % counter for draws

% save history for W
historyWW = zeros(1, lengthEpisode);
historyWS = zeros(1, lengthEpisode);
historyWD = zeros(1, lengthEpisode);

% save history of Q and N
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);

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

    % save the history
    historyQ(:,i) = Q;
    historyN(:, i) = N;

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

% plot the history of Q
figure()
plot(historyQ', 'LineWidth',2)
ylabel('Q')
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of N
figure()
plot(historyN', 'LineWidth', 2)
ylabel('N')
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

figure()
hold on
plot(historyWW', 'LineWidth', 2)
plot(historyWS', 'LineWidth', 2, 'LineStyle','--')
plot(historyWD', 'LineWidth', 2, 'LineStyle',':')
hold off
legend('W_W', 'W_S', 'W_D')
title('W')

% convergence of Q for number of episodes tending to infinity
clear
close all
clc

rng(42) % set the random seed

A = 5; % dimension action space
alpha = 1e-1; % update step for preferences
beta = 1e-3; % update step for rewards
lengthEpisode = 1e4; % number of actions to take

H = zeros(A, 1); % preferences of actions
N = zeros(A, 1); % number of times we take each action
avg_r = 0; % initialization of average reward

% save history of H
historyH = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);

for i = 1:lengthEpisode
    Proba = exp(H)/sum(exp(H)); % Compute softmax for each action

    % choose action based on softmax
    csProba = cumsum(Proba);
    agent_int = find(rand < csProba, 1, "first");

    r = bandit(agent_int, lengthEpisode, i); % compute reward

    H(agent_int) = H(agent_int) + alpha*(r - avg_r)*(1-Proba(agent_int)); % update taken action preference
    N(agent_int) = N(agent_int) + 1;

    % update not-taken actions preferences
    notagent_int = 1:A;
    notagent_int(agent_int) = [];
    H(notagent_int) = H(notagent_int) - alpha*(r - avg_r)*Proba(notagent_int);

    avg_r = avg_r + beta*(r-avg_r); % update average reward with fixed step

    % save the history
    historyH(:,i) = H;
    historyN(:, i) = N;
end

%% plots

% plot the history of Q
figure()
plot(historyH','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of N
figure()
plot(historyN','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')
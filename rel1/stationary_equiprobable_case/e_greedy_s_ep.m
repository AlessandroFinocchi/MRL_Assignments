clear
close all
clc

rng(42) % set the random seed

A = 5; % dimension action space
epsilon = 0.1; % probability we take a random action
lengthEpisode = 20000; % number of actions to take

Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action

% save history of Q and N
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);

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

    % update N and Q
    N(agent_int) = N(agent_int) + 1;
    Q(agent_int) = Q(agent_int) + 1/N(agent_int)*(r - Q(agent_int));

    % save the history
    historyQ(:,i) = Q;
    historyN(:, i) = N;
end

%% plots

% plot the history of Q
figure()
plot(historyQ', 'LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of N
figure()
plot(historyN', 'LineWidth', 2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% convergence of Q for number of episodes tending to infinity
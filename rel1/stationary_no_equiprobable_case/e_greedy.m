clear all
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

% convergence of Q for number of episodes tending to infinity
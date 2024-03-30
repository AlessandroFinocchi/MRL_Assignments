clear
close all
clc

rng(401) % set the random seed
A = 5; % dimension action space
c = 10; % exploration rate
lengthEpisode = 40000; % number of actions to take
alpha = 5e-2; % step size

Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action

% save history of Q and N
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);

for i = 1:lengthEpisode
    Qext = Q + c*sqrt(log(i)./(N+1)); % extended value function
    % we choose the action that maximized the Qext
    agent_int = find(Qext == max(Qext)); 
    agent_int = agent_int(randi(length(agent_int))); % parity broken by random

    r = bandit(agent_int, lengthEpisode, i); % compute reward

    % update N and Q
    N(agent_int) = N(agent_int) + 1;
    %Q(agent_int) = Q(agent_int) + 1/N(agent_int)*(r - Q(agent_int));
    Q(agent_int) = Q(agent_int) + alpha*(r - Q(agent_int)); % constant updates

    % save the history
    historyQ(:, i) = Q;
    historyN(:, i) = N;
end

%% plots

% plot the history of Q
figure('Position', [0 50 560 420])
plot(historyQ','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of N
figure('Position', [560 50 560 420])
plot(historyN','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

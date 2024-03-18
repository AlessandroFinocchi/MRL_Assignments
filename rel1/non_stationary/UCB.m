clear
close all
clc

rng(42) % set the random seed

A = 5; % dimension action space
c = 10; % exploration rate
lengthEpisode = 20000; % number of actions to take
alpha = 0.1; % step size

q = zeros(A, 1); % initial value of the bandit
Q = ones(A, 1); % estimate of the value of actions
N = zeros(A, 1); % number of times we take each action

% save history of Q and N
historyq = zeros(A, lengthEpisode);
historyQ = zeros(A, lengthEpisode);
historyN = zeros(A, lengthEpisode);

for i = 1:lengthEpisode
    Qext = Q + c*sqrt(log(i)./(N+1)); % extended value function

    % we choose the action that maximized the Qext
    agent_int = find(Qext == max(Qext)); 
    agent_int = agent_int(randi(length(agent_int))); % parity broken by random

    [q,r] = bandit(q, agent_int); % compute reward

    % update N and Q
    N(agent_int) = N(agent_int) + 1;
    Q(agent_int) = Q(agent_int) + 1/N(agent_int)*(r - Q(agent_int));
    Q(agent_int) = Q(agent_int) + alpha*(r - Q(agent_int)); % constant updates

    % save the history
    historyq(:,i) = q;
    historyQ(:, i) = Q;
    historyN(:, i) = N;
end

%% plots

% plot the history of q
figure()
plot(historyq','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of Q
figure()
plot(historyQ','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

% plot the history of N
figure()
plot(historyN','LineWidth',2)
legend('Rock', 'Paper', 'Scissors', 'Spock', 'Lizard')

clear
close all
clc

rng(42) % set the random seed

A = 5; % dimension action space
epsilon = 0.05; % probability we take a random action
lengthEpisode = 200; % number of actions to take
alpha = 0.0125;

Q1 = zeros(A, 1); % estimate of the value of actions for agent 1
N1 = zeros(A, 1); % number of times we take each action for agent 1

Q2 = zeros(A, 1); % estimate of the value of actions for agent 2
N2 = zeros(A, 1); % number of times we take each action for agent 2

W1 = 0; % win counter for agent 1
W2 = 0; % win counter for agent 2
WD = 0; % draws

B1 = 0; % best choice for agent 1
B2 = 0; % best choice for agent 2

% history of Q, N, W and B
historyQ1 = zeros(A, lengthEpisode); % for agent 1
historyN1 = zeros(A, lengthEpisode);
historyW1 = zeros(1, lengthEpisode);
historyB1 = zeros(1, lengthEpisode);
historyQ2 = zeros(A, lengthEpisode); % for agent 2
historyN2 = zeros(A, lengthEpisode);
historyW2 = zeros(1, lengthEpisode);
historyB2 = zeros(1, lengthEpisode);
historyWD = zeros(1, lengthEpisode); % for draws

for i = 1:lengthEpisode

    % Agent 1 chooses action
    if rand < epsilon
        agent1_int = randi(A); % we take a random action
    else
        agent1_int = find(Q1 == max(Q1), 1, 'first'); % we take the greedy action
    end

     % Agent 2 chooses action
    if rand < epsilon
        agent2_int = randi(A); % we take a random action
    else
        agent2_int = find(Q2 == max(Q2), 1, 'first'); % we take the greedy action
    end

    % update B
    B1 = find(Q1 == max(Q1), 1, 'first');
    B2 = find(Q2 == max(Q2), 1, 'first');

    % compute reward
    [r1, r2] = bandit_fight(agent1_int, agent2_int); 

    % update N and Q
    N1(agent1_int) = N1(agent1_int) + 1;
    % Q1(agent1_int) = Q1(agent1_int) + 1/N1(agent1_int)*(r1 - Q1(agent1_int));
    Q1(agent1_int) = Q1(agent1_int) + alpha*(r1 - Q1(agent1_int));

    N2(agent2_int) = N2(agent2_int) + 1;
    % Q2(agent2_int) = Q2(agent2_int) + 1/N2(agent2_int)*(r2 - Q2(agent2_int));
    Q2(agent2_int) = Q2(agent2_int) + alpha*(r2 - Q2(agent2_int));

    % update W
    if r1 == 1
        W1 = W1 + 1;
    elseif r1 == -1
        W2 = W2 + 1;
    else
        WD = WD + 1;
    end

    % save the history
    historyQ1(: ,i) = Q1; % for agent 1
    historyN1(:, i) = N1;
    historyW1(:, i) = W1;
    historyB1(:, i) = B1;
    historyQ2(:, i) = Q2; % for agent 2
    historyN2(:, i) = N2;
    historyW2(:, i) = W2;
    historyB2(:, i) = B2;
    historyWD(:, i) = WD; % for draws

end

%% plots

% plot the history of Q
figure()
hold on
plot(historyQ1', 'LineWidth', 2)
plot(historyQ2', 'LineWidth', 2, 'LineStyle','--')
hold off
legend('Rock_1', 'Paper_1', 'Scissors_1', 'Spock_1', 'Lizard_1', 'Rock_2', 'Paper_2', 'Scissors_2', 'Spock_2', 'Lizard_2')
title('Q')

% plot the history of N
figure()
hold on
plot(historyN1', 'LineWidth', 2)
plot(historyN2', 'LineWidth', 2, 'LineStyle','--')
hold off
legend('Rock_1', 'Paper_1', 'Scissors_1', 'Spock_1', 'Lizard_1', 'Rock_2', 'Paper_2', 'Scissors_2', 'Spock_2', 'Lizard_2')
title('N')

% plot the history of V
figure()
hold on
plot(historyW1', 'LineWidth', 2)
plot(historyW2', 'LineWidth', 2, 'LineStyle','--')
plot(historyWD', 'LineWidth', 2, 'LineStyle',':')
hold off
legend('W_1', 'W_2', 'W_D')
title('W')

% plot the history of B
figure()
hold on
stairs(historyB1', 'LineWidth', 2)
stairs(historyB2', 'LineWidth', 2, 'LineStyle','--')
hold off
legend('B_1', 'B_2')
title('B')
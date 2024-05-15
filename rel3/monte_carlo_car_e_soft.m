clear all
close all
clc

rng(42)

% init track
W = 10;
H = 5;
track = simple_track(W, H);
speedCap = 2;

gamma = 1; % discount factor;
numEpisodes = 50; % number of episodes to mean
epsilon = 1e-1;

S = W*H*(speedCap*2+1)^2; % total number of states;
A = 3*3; % number of action

maxSteps = S*2;

policy = randi(A,[S,1]); % policy

% Q = zeros(S, A); % quality function
% N = zeros(S, A); % counter of visits

iteration_counter = 0;

while true

    Q = zeros(S, A); % quality function
    N = zeros(S, A); % counter of visits
    
    iteration_counter = iteration_counter + 1;

    numEpisodes = min(5e4, numEpisodes * 1.10);

    for j = 1:numEpisodes
        step_counter = 0;
        % beginning of episode
        % fprintf("Begin episode %d.%d -> ", iteration_counter, j);
        s0 = randi(S);
        a0 = randi(A);
        states = s0;
        actions = a0;
        rewards = [];
        s = s0;
        a = a0;
        sp = s0;
        while sp ~= -1 && step_counter < maxSteps
            
            [a_row, a_col] = ind2sub([3,3], a);
            % traslate back acceleration
            a_col = a_col - 2;
            a_row = a_row -2;
            [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], sp);
            v_row = v_row - speedCap - 1;
            v_col = v_col - speedCap - 1;
            % fprintf("row %d, col %d v_row %d v_col %d a_row %d a_col %d\n", row, col, v_row, v_col, a_row, a_col);
            % pause(0.2);

            [sp,r] = carWrapper(track, W, H, speedCap, s, a);
            step_counter = step_counter + 1;
            rewards = [rewards, r];

            if sp ~= -1
                states = [states, sp];
                a = policy(sp);
                if rand < epsilon
                    a = randi(A);
                end
                actions = [actions, a];
                s = sp;
            end

        end

        if step_counter < (maxSteps - 1)
            G = 0;
            for i = length(actions):-1:1 % explore the episode backwards
                G = gamma*G + rewards(i);
                St = states(i);
                At = actions(i);
                N(St, At) = N(St, At) + 1;
                Q(St, At) = Q(St, At) + 1/N(St, At)*(G - Q(St, At));
            end
            fprintf("Episode %d.%d -> ", iteration_counter, j);
            fprintf("took %d steps.\n", step_counter);
        else
            numEpisodes = numEpisodes + 1;
            % fprintf("skipped.\n", step_counter);
        end

        
        
    end

    newpolicy = zeros(S,1);
    % update the policy as greedy w.r.t. Q
    for s = 1:S
        newpolicy(s) = find(Q(s,:) == max(Q(s, :)), 1, 'first');
    end

    % if policy doesn't change stop
    fprintf("Norm: %.3f\n", norm(newpolicy-policy,inf));
    if norm(newpolicy-policy, inf) <= 0.5
        break
    else
        policy = newpolicy;
    end

end

%% print policy

for s=1:S

    a = policy(s);

    [a_row, a_col] = ind2sub([3,3], a);
    % traslate back acceleration
    a_col = a_col - 2;
    a_row = a_row -2;
    [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], s);
    v_row = v_row - speedCap - 1;
    v_col = v_col - speedCap - 1;
    fprintf("s:(row: %d, col: %d v_row: %d v_col: %d) <-> a:(a_row: %d, a_col: %d)\n", row, col, v_row, v_col, a_row, a_col);

end



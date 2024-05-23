clear all
close all
clc

rng(41)

% init track
[track, H, W] = medium_track();
speedCap = 2;

numEpisodes = 1; % number of episodes to mean

S = W*H*(speedCap*2+1)^2; % total number of states;
A = 3*3; % number of action

maxSteps = S;

policy = randi(A,[S,1]); % policy

Q = ones(S, A) .* -maxSteps; % quality function
N = zeros(S, A);
% alpha = 0.25;

iteration_counter = 0;

while true

    iteration_counter = iteration_counter + 1;
    skipped = 0;
    j = 1;

    while j <= numEpisodes
        
        step_counter = 0;
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

            [sp,r] = carWrapper(track, W, H, speedCap, s, a);
            step_counter = step_counter + 1;
            rewards = [rewards, r];

            if sp ~= -1
                states = [states, sp];
                a = policy(sp);
                actions = [actions, a];
                s = sp;
            end

        end

        if step_counter < (maxSteps - 1)
            % First visit
            already_visited = [];
            for i = 1:length(actions)
                St = states(i);
                At = actions(i);
                stateActionIndex = sub2ind([S,A], St, At);
                if ~any(already_visited == stateActionIndex)
                    already_visited = [already_visited, stateActionIndex];
                    G = 0;
                    for k = i+1:length(rewards)
                        G = G + rewards(k);
                    end
                    % Q(St, At) = Q(St, At) + alpha*(G - Q(St, At));
                    N(St, At) = N(St, At) + 1;
                    Q(St, At) = Q(St, At) + 1/N(St, At)*(G - Q(St, At));
                end
            end

            if iteration_counter < 10
                fprintf("Episode %d.%d/%d+%d -> ", iteration_counter, j, numEpisodes, skipped);
                fprintf("took %d steps.\n", step_counter);
            end

            j = j + 1;
        else
            if iteration_counter < 30
                skipped = skipped + 1;
                fprintf("Episode %d.%d/%d+%d -> ", iteration_counter, j, numEpisodes, skipped);
                fprintf("retry.\n");
            end
        end

    end

    % update number of episodes
    numEpisodes = min(1000, max(floor(numEpisodes * 1.10), numEpisodes + 1));

    newpolicy = zeros(S,1);
    % update the policy as greedy w.r.t. Q
    for s = 1:S
        % newpolicy(s) = find(Q(s,:) == max(Q(s, :)), 1, 'first');
        % newpolicy(s) = find(Q(s,:) == max(Q(s, :)), 1, 'last');
        index = find(Q(s,:) == max(Q(s, :)));
        newpolicy(s) = index(randi(length(index)));
    end


    % if policy doesn't change stop
    s = policy~=newpolicy;
    fprintf("Policy changed at iteration %d: %.3f.\n" + ...
        "Mean exploration of Q: %.2f\n" + ...
        "Unexplored entries of Q: %d/%d\n\n", ...
        iteration_counter, sum(s), ...
        mean(mean(N)), ...
        sum(sum(any(N==0, [S,A]))), S*A);
    if sum(s) < length(policy) * 0.01
        break
    else
        policy = newpolicy;
        graph_policy(track, policy, W, H, speedCap, iteration_counter);
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

%% graph policy
iterative_graph_policy(track, policy, W, H, speedCap, iteration_counter);

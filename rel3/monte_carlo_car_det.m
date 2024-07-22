clear all
close all
clc

rng(42)

% init track
[track, H, W] = xxl_track();
speedCap = 5;

numEpisodes = 1;            % number of episodes
maxNumEpisodes = 50;

S = W*H*(speedCap*2+1)^2;   % total number of states;
A = 3*3;                    % number of action

% for stop too long episodes
maxSteps = sqrt(S);

policy = randi(A,[S,1]); % policy

Q = ones(S, A) .* -maxSteps; % quality function
alpha = 0.2;
N = zeros(S, A);

iteration_counter = 0;
total_skipped_episodes = 0;
total_valid_episodes = 0;

while true

    iteration_counter = iteration_counter + 1;
    skipped = 0;
    j = 1;

    while j <= numEpisodes
        explored_percentage = sum(sum(any(N==0, [S,A]))) / (S*A);
        unexploredStates = find(N(:,:) == 0);
        % take an unexplored state action with probabililty as the
        % percentage of unexplored state action
        if ~isempty(unexploredStates) && randi(1) < explored_percentage
            [s0, a0] = ind2sub([S,A], unexploredStates(randi(length(unexploredStates))));
        else
            s0 = randi(S);
            a0 = randi(A);
        end
        
        step_counter = 0;
        states = s0;
        actions = a0;
        rewards = [];
        s = s0;
        a = a0;
        sp = s0;

        visitedQ = [];
        loopCounter = 0;
        skippedEpisode = false;

        while sp ~= -1
            % check if state-action has been visited more than five times or if more than
            % maxSteps steps has been made
            if (any(visitedQ == sub2ind([S,A], s, a))) || step_counter >= maxSteps
                loopCounter = loopCounter + 1;
                if loopCounter >= 5 || step_counter >= maxSteps
                    skippedEpisode = true;
                    break
                end
            else
                visitedQ = [visitedQ, sub2ind([S,A], s, a)];
            end
            
            [sp,r] = carWrapper(track, H, W, speedCap, s, a);
            step_counter = step_counter + 1;
            rewards = [rewards, r];

            if sp ~= -1
                states = [states, sp];
                a = policy(sp);
                actions = [actions, a];
                s = sp;
            end

        end

        if ~skippedEpisode
            % First visit
            already_visited = [];
            for i = 1:length(actions)
                St = states(i);
                At = actions(i);
                stateActionIndex = sub2ind([S,A], St, At);
                % if the state-action has not yet been visited then update
                if ~any(already_visited == stateActionIndex)
                    already_visited = [already_visited, stateActionIndex];
                    G = 0;
                    
                    for k = i+1:length(rewards)
                        G = G + rewards(k);
                    end
                    % Q(St, At) = Q(St, At) + alpha*(G - Q(St, At));
                    N(St, At) = N(St, At) + 1;
                    if N(St,At) == 1
                        Q(St,At) = G;
                    else
                        Q(St, At) = Q(St, At) + alpha*(G - Q(St, At));
                    end
                end
            end
            j = j + 1;
            total_valid_episodes = total_valid_episodes + 1;
        else
            skipped = skipped + 1;
            total_skipped_episodes = total_skipped_episodes + 1;
        end

    end

    % update number of episodes
    numEpisodes = min(maxNumEpisodes, max(floor(numEpisodes * 1.10), numEpisodes + 1));

    newpolicy = zeros(S,1);
    % update the policy as greedy w.r.t. Q
    for s = 1:S
        index = find(Q(s,:) == max(Q(s, :)));
        newpolicy(s) = index(randi(length(index)));
    end

    s = policy~=newpolicy;

    fprintf("Policy changed at iteration %d: %d.\n" +...
        "After %d+%d episodes.\n" + ...
        "After %d+%d total episodes.\n" + ...
        "Mean exploration of Q  : %.2f\n" + ...
        "Unexplored entries of Q: %d/%d, approx %.2f%%\n\n", ...
        iteration_counter, sum(s), ...
        numEpisodes, skipped, ...
        total_valid_episodes, total_skipped_episodes, ...
        mean(mean(N)), ...
        sum(sum(any(N==0, [S,A]))), S*A, sum(sum(any(N==0, [S,A]))) / (S*A)*100);

    policy = newpolicy;
    graph_policy(track, policy, W, H, speedCap, iteration_counter);
    % if policy doesn't change stop
    % if sum(s) <= (S*A)*0.05 || (sum(sum(any(N==0, [S,A]))) / S*A) < 0.05
    % if (sum(sum(any(N==0, [S,A]))) / (S*A)) < 0.05
    if (sum(sum(any(N==0, [S,A]))) / (S*A)) < 0.10
        break;
    end

end

    

%% print policy

% for s=1:S
% 
%     a = policy(s);
% 
%     [a_row, a_col] = ind2sub([3,3], a);
%     % traslate back acceleration
%     a_col = a_col - 2;
%     a_row = a_row -2;
%     [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], s);
%     v_row = v_row - speedCap - 1;
%     v_col = v_col - speedCap - 1;
%     fprintf("s:(row: %d, col: %d v_row: %d v_col: %d) <-> a:(a_row: %d, a_col: %d)\n", row, col, v_row, v_col, a_row, a_col);
% 
% end

%% graph policy
iterative_graph_policy(track, policy, W, H, speedCap, iteration_counter);

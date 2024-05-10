clear all
close all
clc

rng(42)

% init track
W = 10;
H = 5;
track = simple_track(W, H);
speedCap = 1;
max_steps = 1000; % max number of steps for each episodes

gamma = 1; % discount factor;
numEpisodes = 1e2; % number of episodes to mean

S = W*H*(speedCap*2+1)^2; % total number of states;
A = 3*3; % number of action

policy = randi(A,[S,1]); % policy
Q = zeros(S, A); % quality function
while true
    N = zeros(S, A); % counter of visits
    for j = 1:numEpisodes
        fprintf("start %d\n",  j)
        % beginning of episode
        % exploring start
        s0 = randi(S);
        a0 = randi(A);
        states = s0;
        actions = a0;
        rewards = [];
        s = s0;
        a = a0;
        sp = s0;
        step_counter = 0; % count the number of the step to avoid cycling paths
        while sp ~= -1 && step_counter < max_steps
            step_counter = step_counter + 1;
            [a_row, a_col] = ind2sub([3,3], a);
            % traslate back acceleration
            a_col = a_col - 2;
            a_row = a_row -2;
            [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], sp);
            v_row = v_row - speedCap - 1;
            v_col = v_col - speedCap - 1;
            if j == 3
                % pause(1);
            end
            fprintf("row %d, col %d v_row %d v_col %d a_row %d a_col %d sc %d \n", row, col, v_row, v_col, a_row, a_col, step_counter)
            [sp,r] = carWrapper(track, W, H, speedCap, s, a);
            rewards = [rewards, r];
            if sp ~= -1 && step_counter < max_steps
                states = [states, sp];
                a = policy(sp);
                actions = [actions, a];
                s = sp;
            end
        end

        G = 0;
        for i = length(actions):-1:1 % explore the episode backwards
            G = gamma*G + rewards(i);
            St = states(i);
            At = actions(i);
            N(St, At) = N(St, At) + 1;
            Q(St, At) = Q(St, At) + 1/N(St, At)*(G - Q(St, At));
        end
        % [c1,c2,ua] = ind2sub([C1,C2,UA], states)
        % myHand = c1 + 11;
    end
    newpolicy = zeros(S,1);
    % update the policy as greedy w.r.t. Q
    for s = 1:S
        index = find(Q(s,:) == max(Q(s, :)));
        newpolicy(s) = randi(length(index));
        % newpolicy(s) = find(Q(s,:) == max(Q(s, :)), 1, 'last');
    end
    % if policy doesn't change stop
    if norm(newpolicy-policy,2) <= 2.5
        break
    else
        disp(norm(newpolicy-policy,2))
        policy = newpolicy;
    end
end

%% graphics

Vstar = zeros(S, 1);
for s = 1:S
    Vstar(s) = max(Q(s,:));
end

[myHand, dealerHand, usableAce] = ind2sub([C1, C2, UA], 1:S);
myHand = myHand + 11;

figure('Position',[10 10 600 300])
subplot(1,2,1)
indUA = find(usableAce == 1);
mH = reshape(myHand(indUA),[C1,C2]);
dH = reshape(dealerHand(indUA),[C1,C2]);
pol = reshape(policy(indUA),[C1,C2]);
V1 = reshape(Vstar(indUA),[C1,C2]);
contourf(mH, dH, pol, [1,2])

subplot(1,2,2)
indUA = find(usableAce == 2);
mH = reshape(myHand(indUA),[C1,C2]);
dH = reshape(dealerHand(indUA),[C1,C2]);
pol = reshape(policy(indUA),[C1,C2]);
V2 = reshape(Vstar(indUA),[C1,C2]);
contourf(mH, dH, pol, [1,2])

figure('Position',[10 10 600 300])
subplot(1,2,1)
surf(mH, dH, V1)

subplot(1,2,2)
surf(mH, dH, V2)
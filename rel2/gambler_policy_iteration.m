clear all
close all
clc

rng(42)
load gambler_model.mat
gamma = 1;
toll = 1e-4;

policy = randi(A, [S, 1]);

vpi = zeros(S,1);
while true
    % policy evaluation step
    vpi = iterative_policy_evaluation(S,P,R,policy,gamma,vpi);
    % quality function calculation
    qpi = zeros(S,A);
    % new policy
    policyp = zeros(S,1);
    for s = 1:S
        for a = 1:A
            % definition
            qpi(s,a) = R(s,a) + gamma*P(s,:,a)*vpi;
        end 
        % policy improvement
        policyp(s) = find(qpi(s,:) == max(qpi(s,:)),1,"first");
    end

    % condition to interrupt the while - policy stable
    if norm(policy-policyp,inf) == 0
        break;
    else
        policy = policyp;
    end
end

%% find optimal actions for each state

qpi_intervals = zeros(S,A);
optimal_actions = [];
optimal_states = [];
maxqpi = 0;

for s = 1:S-1
    %for each row find the max value
    maxqpi = max(qpi(s,:));
    for a = 1:min(s,A) - 1
       if qpi(s,a) >= maxqpi - toll
           qpi_intervals(s,a) = 1;
           optimal_states = horzcat(optimal_states, s-1);
           optimal_actions = horzcat(optimal_actions, a);
       end
    end
end

%% plots

scatter(optimal_states, optimal_actions)
xlim([0, S-1]);
ylim([0, A]);
xlabel('Dollars');
ylabel('Bet');
% Set custom x-axis tick labels for specific locations
default_xticklabels = xticklabels;
default_xticklabels{1} = "Loss";
default_xticklabels{S} = "Win";
xticklabels(default_xticklabels); % Set the labels for the ticks

%%
stem(vpi)
xlim([-1, S+1]);
ylim([-1.5, 1.5]);
xlabel('States');
ylabel('Actions');
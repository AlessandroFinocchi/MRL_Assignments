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

%-----------------plot the optimal actions---------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
scatter(optimal_states, optimal_actions, '.')
xlim([0, S+1]);
ylim([0, (A/2)*1.2]);
xlabel('Dollars', 'FontSize', 18);
ylabel('Bet', 'FontSize', 18);
default_xticklabels = xticklabels;
default_xticklabels{1} = "Loss";
default_xticklabels{11} = "Win";
xticklabels(default_xticklabels); % Set the labels for the ticks
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save
saveas(gcf, "graphs/policy_iteration/Policy", "png")
%--------------------------------------------------------------------------


%-----------------plot the value function----------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
% title('Value function')
stem(vpi, 'LineWidth', 1.5)
xlabel('States', 'FontSize', 18);
xlim([-1,   S+1]);
ylabel('Actions', 'FontSize', 18);
ylim([-1.2, 1.2]);
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save
saveas(gcf, "graphs/policy_iteration/value_function", "png")
%--------------------------------------------------------------------------

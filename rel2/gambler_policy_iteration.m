clear all
close all
clc

rng(42)
load gambler_model.mat
gamma = 1;

policy = randi(A, [S, 1]);

vpi = zeros(S,1);
while true
    % policy evaluation step
    % vpi = policy_eval(S,P,R,policy,gamma);
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
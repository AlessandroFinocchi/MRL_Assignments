clear all
close all
clc

rng(1)
load gambler_model.mat
gamma = 0.9;

policy = randi(A, [S, 1]);


n1 = 30;
n2 = 30;

XX = zeros(n1+1, n2+1);
YY = zeros(n1+1, n2+1);
ZZ = zeros(n1+1, n2+1);
PP = zeros(n1+1, n2+1);

vpi = zeros(S,1);
% tic
while true
    % policy evaluation step
    vpi = policy_eval(S,P,R,policy,gamma);
    % vpi = iterative_policy_eval(S,P,R,policy,gamma,vpi);
    % quality function
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
% toc

% plot the obtained results
for s = 1:S
    [num1, num2] = ind2sub([n1+1 n2+1], s);
    XX(s) = num1-1;
    YY(s) = num2-1;
    ZZ(s) = vpi(s);
    PP(s) = policy(s);
end

% plot the policy
figure(1)
contourf(XX,YY,PP,1:A)

% plot the value function
figure(2)
surf(XX,YY,ZZ)
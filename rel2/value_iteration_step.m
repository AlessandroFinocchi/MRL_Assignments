function [vpin, policy] = value_iteration_step(S,A,P,R,gamma,vpi)

% initialize matrices
q = zeros(S,A);
vpin = zeros(S,1);
policy = zeros(S,1);

% we loop for all the state
for s = 1:S 
    for a = 1:A
        q(s,a) = R(s,a) + gamma*P(s,:,a)*vpi;
    end
    % synchronous substitution
    vpin(s) = max(q(s,:));
    policy(s) = find(q(s,:) == max(q(s,:)),1,"first");
end

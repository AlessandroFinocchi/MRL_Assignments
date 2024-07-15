clear all
close all
clc

rng(42)
load gambler_model.mat
gamma = 1;
toll = 6e-5;

vpi = zeros(S,1);
while true
    % perform a value iteration step
    [vpin, policy] = value_iteration_step(S,A,P,R,gamma,vpi);

    % condition to interrupt the iteration - value function converged
    if norm(vpin - vpi, inf) < toll
        break;
    else
        vpi = vpin;
    end
end

%% plots

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
saveas(gcf, "graphs/value_iteration/value_function", "png")
%--------------------------------------------------------------------------

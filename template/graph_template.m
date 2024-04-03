clear
close all
clc

lengthEpisode = 1e3;

% ----------Setup match result history-----------------
historyW = zeros(3, lengthEpisode);     % history of match result
W = [0,0,0];                            % counter for [agent 1 win, agent 2 win, draws]
% -----------------------------------------------------

for i = 1:lengthEpisode
   
    r1 = (randi(3) - 2);                  % fictional update

    % ---------Update match result history---------------------
    if r1 == 1
        W = W + [1, 0, 0];
    elseif r1 == -1
        W = W + [0, 1, 0];
    else
        W = W + [0, 0, 1];
    end
    historyW(:,i) = W;
    %----------------------------------------------------------
end

%-----------------plot the history of W------------------------------------
% Fixed
figure('Position', [0 0 1280 720])
hold on
% Graph content
title('W')
plot(historyW(1,:)', 'LineWidth', 1.5)
plot(historyW(2,:)', 'LineWidth', 1.5, 'LineStyle','--')
plot(historyW(3,:)', 'LineWidth', 1.5, 'LineStyle',':')
lgn = legend('Wins_1', 'Wins_2', 'Draws');
set(gca, 'ColorOrder', colors(3))
% Fixed
grid on
lgn.Location = 'northeastoutside';
hold off
% Save
saveas(gcf, "graphs/template/W", "png")
%--------------------------------------------------------------------------
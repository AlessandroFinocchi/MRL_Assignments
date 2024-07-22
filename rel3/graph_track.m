
%% Graph track

[track, H, W] = track_hard_walled_15();

% print map
figure(1)
clf
axis equal
xlim([1 W+1])
ylim ([1 H+1])
set(gca,'xtick',1:W)
set(gca,'ytick',1:H)
grid on
box on
hold on

% print holes 
holes = find(track(:,:) == 0);
for i = 1:length(holes)
    [row, col] = ind2sub([H, W], holes(i));
    rectangle('Position',[col, row, 1 1],'FaceColor','black','EdgeColor','black');
end

% print starting line 
holes = find(track(:,:) == 2);
for i = 1:length(holes)
    [row, col] = ind2sub([H, W], holes(i));
    rectangle('Position',[col, row, 1 1],'FaceColor','blue','EdgeColor','blue');
end

% print finish line 
holes = find(track(:,:) == 3);
for i = 1:length(holes)
    [row, col] = ind2sub([H, W], holes(i));
    rectangle('Position',[col, row, 1, 1],'FaceColor','green','EdgeColor','green');
end

% plot(cols+0.5,rows+0.5,'Marker','o','MarkerSize',10, 'MarkerFaceColor','b','LineWidth',3);
% quiver(cols+0.5, rows+0.5, v_cols, v_rows, "off", 'MaxHeadSize', 0.1, LineWidth=1, Color="#4DBEEE");
% quiver(cols+0.5, rows+0.5, a_cols, a_rows, "off", 'MaxHeadSize', 0.1, LineWidth=1, Color="red");

hold off
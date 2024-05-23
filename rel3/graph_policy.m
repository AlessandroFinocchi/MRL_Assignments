function [] = graph_policy(track, policy, W, H, speedCap)

    % initialize starting point
    starting_line = find(track(:,:) == 2);
    current_position = starting_line(randi(length(starting_line)));
    [curr_row, curr_col] = ind2sub([W,H], current_position);
    start_r = curr_row;
    start_c = curr_col;

    % initialize starting speed
    v_row = speedCap + 1;
    v_col = speedCap + 1;

    % initialize history
    states = [];
    actions = [];
    rows = [];
    cols = [];
    v_rows = [];
    v_cols = [];

    current_state = sub2ind([W, H, speedCap*2+1, speedCap*2+1], curr_row, curr_col, v_row, v_col);

    while current_state ~= -1
        next_action = policy(current_state);
        states = [states, current_state];
        actions = [actions, next_action];

        [a_row, a_col] = ind2sub([3,3], next_action);
        % traslate back acceleration
        a_col = a_col - 2;
        a_row = a_row -2;
        [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], current_state);
        v_row = v_row - speedCap - 1;
        v_col = v_col - speedCap - 1;
        fprintf("graph-policy:(row: %d, col: %d v_row: %d v_col: %d) <-> a:(a_row: %d, a_col: %d)\n", row, col, v_row, v_col, a_row, a_col);
        rows = [rows, row];
        cols = [cols, col];
        v_rows = [v_rows, v_row];
        v_cols = [v_cols, v_col];

        [current_state, ] = carWrapper(track, W, H, speedCap, current_state, next_action);
        
    end

    % update graph
    figure(1)
    clf
    rectangle('Position',[start_c, start_r, 1 1],'FaceColor','g',...
        'EdgeColor','g');
    % for ii = 1:numx
    %     text(ii+0.5, 0.5, num2str(wind(ii)),'interpreter','latex');
    % end
    axis equal
    xlim([1 W+1])
    ylim  ([1 H+1])
    set(gca,'xtick',1:W)
    set(gca,'ytick',1:H)
    set(gca,'xticklabels',[])
    set(gca,'yticklabels',[])
    grid on
    box on
    hold on
    plot(cols+0.5,rows+0.5,'Marker','o','MarkerSize',10,...
        'MarkerFaceColor','b','LineWidth',3);
    title(['Episode - ',num2str(e)],'Interpreter','latex')
    pause(1);



end


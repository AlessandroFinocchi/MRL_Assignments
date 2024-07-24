function [] = iterative_graph_policy(track, policy, W, H, speedCap, iteration)

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
    a_cols = [];
    a_rows = [];

    current_state = sub2ind([W, H, speedCap*2+1, speedCap*2+1], curr_row, curr_col, v_row, v_col);

    steps = 0;
    maxSteps = 10000;

    while current_state ~= -1
        next_action = policy(current_state);
        states = [states, current_state];
        actions = [actions, next_action];
        steps = steps + 1;
        if steps > maxSteps
            disp(steps)
        end

        [a_row, a_col] = ind2sub([3,3], next_action);
        % traslate back acceleration
        a_col = a_col - 2;
        a_row = a_row -2;
        a_cols = [a_cols, a_col];
        a_rows = [a_rows, a_row];
        [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], current_state);
        v_row = v_row - speedCap - 1;
        v_col = v_col - speedCap - 1;
        % fprintf("graph-policy:(row: %d, col: %d v_row: %d v_col: %d) <-> a:(a_row: %d, a_col: %d)\n", row, col, v_row, v_col, a_row, a_col);
        rows = [rows, row];
        cols = [cols, col];
        v_rows = [v_rows, v_row];
        v_cols = [v_cols, v_col];

        [current_state, ] = carWrapper(track, W, H, speedCap, current_state, next_action);
        
    end

    last_row = max(min(row + v_row + a_row, W), 1);
    last_col = max(min(col + v_col + a_col, H), 1);
    rows = [rows, last_row];
    cols = [cols, last_col];
    v_cols = [v_cols, 0];
    v_rows = [v_rows, 0];
    a_cols = [a_cols, 0];
    a_rows = [a_rows, 0];

%% Graph track

    % print map
    
    for j = 1:length(cols)
        figure(1)
        clf
        axis equal
        xlim([1 W+1])
        ylim ([1 H+1])
        set(gca,'xtick',1:W)
        set(gca,'ytick',1:H)
        title(["Iteration: " iteration])
        grid on
        box on
        hold on
    
        % print holes 
        holes = find(track(:,:) == 0);
        for i = 1:length(holes)
            [row, col] = ind2sub([W, H], holes(i));
            rectangle('Position',[col, row, 1 1],'FaceColor','black','EdgeColor','black');
        end
    
        % print starting line 
        holes = find(track(:,:) == 2);
        for i = 1:length(holes)
            [row, col] = ind2sub([W, H], holes(i));
            rectangle('Position',[col, row, 1 1],'FaceColor','blue','EdgeColor','blue');
        end
    
        % print real starting point
        rectangle('Position',[start_c, start_r, 1 1],'FaceColor','cyan','EdgeColor','cyan');
    
        % print finish line 
        holes = find(track(:,:) == 3);  
        for i = 1:length(holes)
            [row, col] = ind2sub([W, H], holes(i));
            rectangle('Position',[col, row, 1, 1],'FaceColor','green','EdgeColor','green');
        end
    
        plot(cols(j)+0.5,rows(j)+0.5,'Marker','o','MarkerSize',10, 'MarkerFaceColor','b','LineWidth',3);
        quiver(cols(j)+0.5, rows(j)+0.5, v_cols(j), v_rows(j), "off", 'MaxHeadSize', 0.3, LineWidth=1, Color="#4DBEEE");
        quiver(cols(j)+0.5, rows(j)+0.5, a_cols(j), a_rows(j), "off", 'MaxHeadSize', 0.3, LineWidth=1, Color="red");
        hold off

        pause(0.8)
    end

    

end


function [row_new, col_new, v_row_new, v_col_new, r]=car( ...
    track, H, W, speedCap, row, col, v_row, v_col, a_row, a_col)
    r = -1; % at each step the reward is -1

    % update speed
    v_row_new = max(min(v_row + a_row, speedCap),-speedCap);
    v_col_new = max(min(v_col + a_col, speedCap),-speedCap);

    % update position
    row_new = max(min(row+v_row_new, H), 1);
    col_new = max(min(col+v_col_new, W), 1);

    % checks on the new position
    switch track(row_new, col_new)
        case 0 % return to the starting line at random
            [row0, col0] = find(track == 2);
            rand_index = randi(length(row0));
            row_new = row0(rand_index);
            col_new = col0(rand_index);
        case 3 % the car crossed the finishing line
           row_new = -1;
           col_new = -1;
        otherwise
    end
            
end
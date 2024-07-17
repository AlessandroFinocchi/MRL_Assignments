function [sp, r] = carWrapper(track, H, W, speedCap, s, a)
    % unpack action to acceleration
    [a_row, a_col] = ind2sub([3,3], a);
    % traslate back acceleration
    a_col = a_col - 2;
    a_row = a_row -2;
    % unpack state to position and speed
    [row, col, v_row, v_col] = ind2sub([H, W, speedCap*2+1, speedCap*2+1], s);
    % traslate back state
    v_row = v_row - speedCap - 1;
    v_col = v_col - speedCap - 1;
    % call car function
    [row_new, col_new, v_row_new, v_col_new, r] = car(track, H, W, speedCap, row, col, v_row, v_col, a_row, a_col);
    %traslate forward speed
    v_row_new = v_row_new + speedCap + 1;
    v_col_new = v_col_new + speedCap + 1;
    % pack state
    if row_new == -1 && col_new == -1 
        sp = -1; 
    else
        sp = sub2ind([H, W, speedCap*2+1, speedCap*2+1], row_new, col_new, v_row_new, v_col_new);
    end
end


function [sp, r] = carWrapper(track, s, a)
    speedCap = 5;
    % unpack action to acceleration
    [a_row, a_col] = ind2sub([3,3], a);
    % traslate back acceleration
    a_col = a_col - 2;
    a_row = a_row -2;
    % unpack state to position and speed
    [row, col, v_row, v_col] = ind2sub([W, H, speedCap*2+1, speedCap*2+1], s);
    % traslate back state
    v_row = v_row - speedCap - 1;
    v_col = v_col - speedCap - 1;
    % call car function
    [row_new, col_new, v_row_new, v_col_new, r]=car(track, row, col, v_row, v_col, a_row, a_col);
    %traslate forward speed
    v_row_new = v_row_new + speedCap + 1;
    v_col_new = v_col_new + speedCap + 1;
    % pack state
    sp = sub2ind([W, H, speedCap*2+1, speedCap*2+1], row_new, col_new, v_row_new, v_col_new);
end


function [xp, yp, vxp, vyp, r] = car(track, x, y, vx, vy, ax, ay)
    H = 20; % the height of the map
    W = 30; % the width of the map
    speedCap = 3; % speed is capped in each direction
    r = -1; % at each step the reward is -1

    % update speed
    vxp = max(min(vx + ax, speedCap),-speedCap);
    vyp = max(min(vy + ay, speedCap),-speedCap);

    % update position
    xp = max(min(x+vxp, W), 0);
    yp = max(min(y+vyp, H), 0);

    % checks on the new position
    switch track(xp, yp)
        case 0 % return to the starting line at random
            [x0, y0] = find(track == 3);
            rand_index = randi(length(x0));
            xp = x0(rand_index);
            yp = y0(rand_index);
        case 3 % the car crossed the finishing line
           xp = -1;
           yp = -1;
        otherwise
    end
            
end
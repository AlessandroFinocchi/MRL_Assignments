function [Ap] = simple_track(H, W)
    hBound = 3; % wall height 
    wBound = 3; % wall width
    Ap = ones(H, W);

    % the outside
    for col = wBound:W
        for row = 1:hBound
            Ap(row,col) = 0;
        end
    end

    % the starting line
    for col = 1:wBound-1
        Ap(1,col) = 2;
    end

    % the finishing line
    for row = hBound+1:H
        Ap(row, W) = 3;
    end
   
end
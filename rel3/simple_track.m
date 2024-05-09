function [Ap] = simple_track(W, H)
    hBound = 15; % wall height 
    wBound = 15; % wall width
    Ap = ones(H, W);
    for x = wBound:W
        for y = 1:hBound
            Ap(y,x) = 0;
        end
    end
    for x = 1:wBound-1
        Ap(1,x) = 2;
    end
    for y = hBound+1:H
        Ap(y, W) = 3;
    end
   
end
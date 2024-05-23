function [Ap, H, W] = medium_track_no_skip_big3()

    H = 3 * 5;
    W = 3 * 5;

    Ap = ones(H, W);
    
    for col = 4:6
        for row = 1:12
            Ap(row, col) = 0;
        end
    end

    for col = 10:12
        for row = 4:15
            Ap(row, col) = 0;
        end
    end

    % the starting line
    for col = 1:3
        for row = 1:1
            Ap(row, col) = 2;
        end
    end

    % the finishing line
    for col = 13:15
        for row = 15:15
            Ap(row, col) = 3;
        end
    end
   
end
function [Ap, H, W] = medium_track_no_skip()

    H = 2 * 5;
    W = 2 * 5;

    Ap = ones(H, W);
    
    for col = 3:4
        for row = 1:8
            Ap(row, col) = 0;
        end
    end

    for col = 7:8
        for row = 3:10
            Ap(row, col) = 0;
        end
    end

    % the starting line
    for col = 1:2
        for row = 1:1
            Ap(row, col) = 2;
        end
    end

    % the finishing line
    for col = 9:10
        for row = 10:10
            Ap(row, col) = 3;
        end
    end
   
end
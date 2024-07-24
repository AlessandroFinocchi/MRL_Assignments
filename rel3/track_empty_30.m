function [Ap, H, W] = track_empty_30()

    H = 6 * 5;
    W = 6 * 5;

    Ap = ones(H, W);
    
    for col = 1:1
        for row = 1:H
            Ap(row, col) = 0;
        end
    end

    for col = W:W
        for row = 1:H
            Ap(row, col) = 0;
        end
    end

    for col = 4:W
        for row = 1:1
            Ap(row, col) = 0;
        end
    end

    for col = 1:W-3
        for row = H:H
            Ap(row, col) = 0;
        end
    end


    % the starting line
    for col = 2:W-1
        for row = 1:1
            Ap(row, col) = 2;
        end
    end

    % the finishing line
    for col = W-2:W-1
        for row = H:H
            Ap(row, col) = 3;
        end
    end
   
end
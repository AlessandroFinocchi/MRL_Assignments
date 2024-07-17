function [Ap, H, W] = xxl_track()

    H = 15;
    W = 15;

    Ap = ones(H, W);
    
    % center wall
    for col = 6:10
        for row = 1:11
            Ap(row, col) = 0;
        end
    end

    % left wall
    for col = 1:1
        for row = 1:15
            Ap(row, col) = 0;
        end
    end

    % top wall
    for col = 1:15
        for row = 15:15
            Ap(row, col) = 0;
        end
    end

    % right wall
    for col = 15:15
        for row = 1:15
            Ap(row, col) = 0;
        end
    end

    % the starting line
    for col = 2:5
        for row = 1:1
            Ap(row, col) = 2;
        end
    end

    % the finishing line
    for col = 11:14
        for row = 1:1
            Ap(row, col) = 3;
        end
    end
   
end


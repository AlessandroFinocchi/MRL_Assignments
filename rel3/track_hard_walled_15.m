function [Ap, H, W] = hard_track_no_skip_walled_big3()

    H = 3 * 5;
    W = 3 * 5;

    Ap = ones(H, W);
    
    for col = 3:4
        for row = 1:12
            Ap(row, col) = 0;
        end
    end

    for col = 7:8
        for row = 4:15
            Ap(row, col) = 0;
        end
    end

    for col = 11:12
        for row = 1:12
            Ap(row, col) = 0;
        end
    end

    for col = 1:15
        for row = 15:15
            Ap(row, col) = 0;
        end
    end

    for col = 5:10
        for row = 1:1
            Ap(row, col) = 0;
        end
     end

    for col = 15:15
        for row = 1:15
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
    for col = 13:14
        for row = 1:1
            Ap(row, col) = 3;
        end
    end
   
end
function [Ap, H, W] = track_single_curve_20()

    H = 20;
    W = 20;

    Ap = ones(H, W);
    
    % bottom right wall
    for col = 7:20
        for row = 1:14
            Ap(row, col) = 0;
        end
    end

    % the starting line
    for col = 1:6
        for row = 1:1
            Ap(row, col) = 2;
        end
    end

    % the finishing line
    for col = 20:20
        for row = 15:20
            Ap(row, col) = 3;
        end
    end
   
end


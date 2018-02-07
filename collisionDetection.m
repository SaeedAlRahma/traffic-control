function collision_pos = collisionDetection(curRobots, vel, i, xy)
% This function checks for potential collisions
% the function, must be on a folder in matlab path

    collision_pos = 0; % no collision by default
        
    for j=i-1:-1:1 % find first car ahead
        % Skip irrelevant robots
        if ((curRobots(4,j) <= 0) ... % robot not in region
            || (curRobots(3,j) ~= curRobots(3,i))) % different lane
           continue % skip
        end
        
        % Check potential collision
        car_i_exp_pos = curRobots(xy,i) + vel(xy,i)*0.2;
        car_j_exp_pos = curRobots(xy,j) + vel(xy,j)*0.2;
        if (abs(car_i_exp_pos - car_j_exp_pos) < 2.1) % collision
            collision_pos = car_j_exp_pos;
        end
        
        return ; % first car ahead found
    end
    
end
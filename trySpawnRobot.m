function robots = trySpawnRobot(curRobots, prob)
% This function controls whether a robot is spawned or not
% the function, must be on a folder in matlab path
% curRobots is the current array of robots
% returns robots, updated array of robots in region
    robots = curRobots;
    
    if (rand < prob) % robot spawned
        % randomly select intersection
        select_road = rand;
        if (select_road < 0.25) % robot driving north
            direction = 1;
        elseif (select_road < 0.50) % robot driving east
            direction = 2;
        elseif (select_road < 0.75) % robot driving south
            direction = 3;   
        else % robot driving west
            direction = 4;
        end
                
        % select robot to spawn
        for i=1:size(robots,2)
            if (robots(4,i) == 0)
               robots(:,i) = spawnRobot(direction);
               break
            end
        end
        
        % check available space in lane
        % this is not an issue for the parameters we are running

    end
    
    
end
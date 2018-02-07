function robot = spawnRobot(dir)
% This function spawns a robot based on its driving direction
% the function, must be on a folder in matlab path
% dir is the driving direction of the robot
% returns robot, updated array of robot position

    switch dir
        case 1 % North
            robot = [3.5 -200 1 0.2];
        case 2 % East
            robot = [-200 -3.5 2 0.2];
        case 3 % South
            robot = [-3.5 200 3 0.2];
        otherwise % West
            robot = [200 3.5 4 0.2];
    end

end
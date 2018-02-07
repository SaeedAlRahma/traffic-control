function [rob, cars, delay, max_delay] = resetRobot(travel_t, c, d, max_d)
% This function resets robot and updates stats
% the function, must be on a folder in matlab path

    % Initialize outputs
    rob = [-300 -300 0 -1]; % reset robots
    max_delay = max_d;
    
    % Update outputs
    cars = c + 1; % increment cars
    delay = d + travel_t; % update delay
    if travel_t > max_delay % update max delay
       max_delay = travel_t;
    end
    
                       
end
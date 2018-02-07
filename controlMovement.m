function [data, vel, delay, max_delay, cars] = controlMovement(curRobots, dt)
% This function controls the robots movement (traffic control)
% the function, must be on a folder in matlab path
% curRobots is the current array of robots
% dt is the time step in simulation
% returns data, an updated array of robots
% returns vel, robots velocities
% returns delay, the total delay of all cars passed region this time step
% returns max_delay, the max delay from current robots
% returns cars, the total number of cars pass region this time step
    
    % Initialize outputs
    vel = zeros(2, size(curRobots,2));
    delay = 0;
    max_delay = 0;
    cars = 0;
    
    %% Traffic Control (Green Light)
    % find closest car to traffic center
    robotsDist = zeros(1, size(curRobots,2));
    for i=1:size(robotsDist,2)
        robotsDist(i) = pdist2(curRobots(1:2,i)', [0 0], 'euclidean');
    end
    [~, IND] = min(robotsDist);

    % select traffic light based on closest car to intersection
    % green light 1 (North/South), green light 0 (East/West)
    % UNCOMMENT disp TO DISPLAY TRAFFIC LIGHT PER DT
    if (curRobots(3,IND)==1) || (curRobots(3,IND)==3)
        traffic_light = 1;
%         disp('Traffic light is North/South')
    else
        traffic_light = 0;
%         disp('Traffic light is East/West')
    end

    %% Traffic Control (car velocities)
    % Constants for direction
    % [north east south west]
    max_speed = [0 20 0 -20; 20 0 -20 0];
    traffic_line = [-6 -6 6 6]; % virtual based on size of robots
    
    % Loop through all robots
    for i=1:size(vel,2)
       if (curRobots(4,i) > 0) % available
           % robot velocity
           dir = curRobots(3,i);
           vel(:,i) = max_speed(:,dir);
           switch dir
               case 1 % North
                   % Check if robot passed the visible region
                   if (curRobots(2,i)+vel(2,i)*dt > 200)
                       [curRobots(:,i), cars, delay, max_delay] = ...
                           resetRobot(curRobots(4,i)-dt, cars, delay, max_delay);
                       continue
                   end
                   
                   if (curRobots(2,i) <= traffic_line(dir) && ~traffic_light)
                       % Collision detection     
                       col_center = collisionDetection(curRobots, vel, i, 2);
                       % Slow down/Stop
                       if col_center ~= 0
                           vel(2,i) = ...
                               ((col_center-2.1)-curRobots(2,i))./dt;
                            % increment delay
                            cur_delay = dt - dt*(vel(2,i)./max_speed(2,dir));
                            curRobots(4,i) = curRobots(4,i)+cur_delay;
                       
                       % Traffic light control
                       elseif curRobots(2,i)+vel(2,i)*dt > traffic_line(dir)
                           % Slow down/Stop
                           vel(2,i) = ...
                               (traffic_line(dir)-curRobots(2,i))./dt;
                            % increment delay
                            cur_delay = dt - dt*(vel(2,i)./max_speed(2,dir));
                            curRobots(4,i) = curRobots(4,i)+cur_delay;
                       end
                   end
               case 2 % East
                   % Check if robot passed the visible region
                   if (curRobots(1,i)+vel(1,i)*dt > 200)
                       [curRobots(:,i), cars, delay, max_delay] = ...
                           resetRobot(curRobots(4,i)-dt, cars, delay, max_delay);
                       continue
                   end
                   
                   if (curRobots(1,i) <= traffic_line(dir) && traffic_light)
                       % Collision detection     
                       col_center = collisionDetection(curRobots, vel, i, 1);
                       % Slow down/Stop
                       if col_center ~= 0
                           vel(1,i) = ...
                               ((col_center-2.1)-curRobots(1,i))./dt;
                            % increment delay
                            cur_delay = dt - dt*(vel(1,i)./max_speed(1,dir));
                            curRobots(4,i) = curRobots(4,i)+cur_delay;
                       
                       % Traffic light control
                       elseif curRobots(1,i)+vel(1,i)*dt > traffic_line(dir)
                           vel(1,i) = ...
                               (traffic_line(dir)-curRobots(1,i))./dt;
                            % increment delay
                            cur_delay = dt - dt*(vel(1,i)./max_speed(1,dir));
                            curRobots(4,i) = curRobots(4,i)+cur_delay;
                       end
                   end
               case 3 % South
                   % Check if robot passed the visible region
                   if (curRobots(2,i)+vel(2,i)*dt < -200)
                       [curRobots(:,i), cars, delay, max_delay] = ...
                           resetRobot(curRobots(4,i)-dt, cars, delay, max_delay);
                       continue
                   end
                   
                   if (curRobots(2,i) >= traffic_line(dir) && ~traffic_light)
                       % Collision detection     
                       col_center = collisionDetection(curRobots, vel, i, 2);
                       % Slow down/Stop
                       if col_center ~= 0
                           vel(2,i) = ...
                               ((col_center+2.1)-curRobots(2,i))./dt;
                            % increment delay
                            cur_delay = dt - dt*(vel(2,i)./max_speed(2,dir));
                            curRobots(4,i) = curRobots(4,i)+cur_delay;
                       
                       % Traffic light control
                       elseif curRobots(2,i)+vel(2,i)*dt < traffic_line(dir)
                           vel(2,i) = ...
                               (traffic_line(dir)-curRobots(2,i))./dt;
                            % increment delay
                            cur_delay = dt - dt*(vel(2,i)./max_speed(2,dir));
                            curRobots(4,i) = curRobots(4,i)+cur_delay;
                       end
                   end
               otherwise % West
                   % Check if robot passed the visible region
                   if (curRobots(1,i)+vel(1,i)*dt < -200)
                       [curRobots(:,i), cars, delay, max_delay] = ...
                           resetRobot(curRobots(4,i)-dt, cars, delay, max_delay);
                       continue
                   end
                   
                   if (curRobots(1,i) >= traffic_line(dir) && traffic_light)
                       % Collision detection     
                       col_center = collisionDetection(curRobots, vel, i, 1);
                       % Slow down/Stop
                       if col_center ~= 0
                           vel(1,i) = ...
                               ((col_center+2.1)-curRobots(1,i))./dt;
                            % increment delay
                            cur_delay = dt - dt*(vel(1,i)./max_speed(1,dir));
                            curRobots(4,i) = curRobots(4,i)+cur_delay;
                       
                       % Traffic light control
                       elseif curRobots(1,i)+vel(1,i)*dt < traffic_line(dir)
                           vel(1,i) = ...
                               (traffic_line(dir)-curRobots(1,i))./dt;
                             % increment delay
                            cur_delay = dt - dt*(vel(1,i)./max_speed(1,dir));
                            curRobots(4,i) = curRobots(4,i)+cur_delay;
                       end
                   end
           end               
       end
    end
    
    %% Update robot data output
    data = curRobots;
end    

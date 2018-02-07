% Saeed Alrahma
% November 21, 2017
% ECE 590-17: Distributed Robotic Systems
% Assignment 3 - Coordination
%
% I have adhered to the Duke Community Standards in completing this
% assignment

clear;

%% Parameters
% Robot Parameters
MAX_NUM_ROBOTS = 400; % Arbitrary number for matrix size
ROBOT_RADIUS = 1; % in meters
VIEW_RANGE = inf; % in meters
ROBOT_MAX_VELOCITY = 20; % in meters
PROB_SPAWN_ROBOT = 0.04; % probably a new robot enters the stage
ROBOT_AREA = pi * ROBOT_RADIUS^2;

% Stage Parameters
REGION_RADIUS = 200; % CHANGE THIS TO ZOOM IN (in meters)
ROAD_WIDTH = 7; % Width of each lane (in meters)
l1 = [ROAD_WIDTH ROAD_WIDTH REGION_RADIUS; REGION_RADIUS ROAD_WIDTH ROAD_WIDTH];
l2 = [-ROAD_WIDTH -ROAD_WIDTH -REGION_RADIUS; REGION_RADIUS ROAD_WIDTH ROAD_WIDTH];
l3 = [-ROAD_WIDTH -ROAD_WIDTH -REGION_RADIUS; -REGION_RADIUS -ROAD_WIDTH -ROAD_WIDTH];
l4 = [ROAD_WIDTH ROAD_WIDTH REGION_RADIUS; -REGION_RADIUS -ROAD_WIDTH -ROAD_WIDTH];
h_div = [-REGION_RADIUS REGION_RADIUS; 0 0];
v_div = [0 0; -REGION_RADIUS REGION_RADIUS];

% Simulation Parameters
SIM_TIME = 120; % total simulation time in seconds
SIM_INTERVAL = 0.01; % in seconds
DT = 0.2; % in seconds (time step)

%% Setup
% Simulation Setup
robot_vel = zeros(2, MAX_NUM_ROBOTS); % velocity array of robots
% robot_data contains x,y position, direction, on-region boolean of robots
% x,y position are xy-plane coordinates
% direction is 'n', 's', 'e', 'w' for north, south, east, and west
% on-region is 1 if car on region, 0 if car out of bounds/ignored
robot_data = zeros(4, MAX_NUM_ROBOTS);
robot_data(1:2,:) = robot_data(1:2,:) - 300; % move robots out of visual region
t = 0.0; % simulation time (in seconds)
total_delay = 0; % total delay of all robots in seconds
total_cars = 0; % total number of cars
last_car_count = 0; % track lasr car count for data collection
max_delay = 0; % Track the maximum delay of a single car
MIN_TRAVEL_TIME = (2*REGION_RADIUS)/ROBOT_MAX_VELOCITY; % min travel time per robot
% Set up files to write data
file1ID = fopen('data_delay.txt','w');
fprintf(file1ID,'Simulation Started! time = 0\n');
fprintf(file1ID,'Total Robots, Avg Delay, Max Delay\n');
fprintf(file1ID,'\t%3.2f, \t\t%3.2f, \t\t%3.2f\n', ...
    total_cars, total_delay/total_cars, max_delay);

% Figure Setup
f1 = setupStage(-REGION_RADIUS, REGION_RADIUS, -REGION_RADIUS, REGION_RADIUS);

%% Plotting
% Plot Stage
stage_plot = plot(l1(1,:), l1(2,:), 'm', ...
                  l2(1,:), l2(2,:), 'm', ...
                  l3(1,:), l3(2,:), 'm', ...
                  l4(1,:), l4(2,:), 'm', ...
                  h_div(1,:), h_div(2,:), 'm--', ...
                  v_div(1,:), v_div(2,:), 'm--');

% Plot Robots
robot_scatter = scatter(robot_data(1,:),robot_data(2,:), 'w', 'filled');

% Size robots properly
sizeRobotToStage(robot_scatter, ROBOT_RADIUS);

hold off
pause(1);

%% Simulatation       
% Simulate for predefined SIM_TIME
while (t < SIM_TIME) 
    %% Traffic Control        
    % Check new robots
    robot_data = trySpawnRobot(robot_data, PROB_SPAWN_ROBOT);
    
    % Control traffic
    [robot_data, robot_vel, delay, max_d, cars_passed] = ...
                    controlMovement(robot_data, DT);
    % Update data
    total_cars = total_cars + cars_passed;
    total_delay = total_delay + delay;
    if max_d > max_delay
        max_delay = max_d;
    end
    if total_cars > last_car_count
        fprintf(file1ID,'\t%3.2f, \t\t%3.2f, \t\t%3.2f\n', ...
            total_cars, total_delay/total_cars, max_delay);
        last_car_count = total_cars;
    end
    
    % Move robots
    robot_data(1:2,:) = robot_data(1:2,:) + (robot_vel*DT);
     
    %% Animation
    t = t+DT; % Time step
    pause(SIM_INTERVAL) % Wait "SIM_INTERVAL" seconds for visualization
    % update robots' positions on plot
    set(robot_scatter,'XData',robot_data(1,:));
    set(robot_scatter,'YData',robot_data(2,:));
    drawnow % update plot
end

%% Calculate remaining robots delay
for i=1:size(robot_data,2)
    if(robot_data(4,i) > 0.2)
        [rob, total_cars, total_delay, max_delay] = ...
            resetRobot(robot_data(4,i)-DT, total_cars, total_delay, max_delay);
    end
end
fprintf(file1ID,'Adding delayed cars still in region\n');
fprintf(file1ID,'\t%3.2f, \t\t%3.2f, \t\t%3.2f\n', ...
    total_cars, total_delay/total_cars, max_delay);

%% Close files
fprintf(file1ID,'Simulation Ended! time = %d\n', t);
fclose(file1ID);
disp('Simulation Finished!')
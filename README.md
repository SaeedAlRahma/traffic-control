# Traffic Control
Multiple robots traveling straight across an intersection as quickly as possible without leaving the road and without colliding with each other

## RUNNING SIMULATION ##
This simulation was completed using MATLAB. In order to run the simulation:
1) Open Matlab
2) Go to the directory containing the code
3) Open coordination.m
4) Run the script (green play sign under the editor tab)

The script will open a figure, plot environment, and animate it as robots move (simulation period is 0.1 seconds, but each frame is 0.2 second). The simulation parameters can be easily modified in the code.

Extra features:
* Control the visual display (ability to zoom): change REGION_RADIUS
* Control simulation time: change SIM_TIME
* Control simulation interval: change SIM_INTERVAL
* Print updated average delay as each car passes the intersection: written to a file: data_delay.txt
	
## Scenario Description ##
Description: Multiple holonomic circular robots of radius 1 m with 360-degree field of view sensors of unlimited range approach a four-way intersection. The width of the road is 7 m and the speed limit is 20 m/s. At each time step dt = 0.2 s, the probability of a robot entering a region of radius 200 m from the intersection in one of the four directions is p = 0.04.

Assumptions: Robots have infinite acceleration. Robots always drive in a straight light:
(North and South can pass the intersection together, East and West can pass the intersection together)

Goal: Travel straight across the intersection as quickly as possible without leaving the road and without colliding with each other.

## SIMULATION DESIGN ##
In the implementation, each robot controls its own speed based on its position, traffic control, and collision detection.
* Each robot (I) predicts collision with robot (J) directly in front of it
  * Robot (I) inquires velocity of robot (J)
  * Robot (I) predicts future position of both robots
    * Slow down/stop if collision is predicted (future distance between centers is less than radius*2)
    * Drive at full speed if no collision is predicted
* Each robot on the region looks at the traffic light
  * Drive at full speed if green/pass
  * Slow down/stop id red/not pass
* Each robot minimizes its own delay by moving as close as possible without collision and breaking traffic control law
* Each robot counts its own delay

The traffic control is simple and allows the closest car to the intersection to pass
* The implementation inherently guarantees no car waits forever
* Traffic control prevents collision in intersection while allowing closest car to pass

## Result Analysis ##
[Demo Simulation - new robot probability = 0.2](https://youtu.be/uL4X5av5guw)

[Demo Simulation - new robot probability = 0.2 (zoomed)](https://youtu.be/Exhr_RjDhgw)

[Demo Simulation - new robot probability = 0.4](https://youtu.be/vLlwCwKr0pk)

Detailed results in [results.docx](https://github.com/SaeedAlRahma/traffic-control/blob/master/results.docx).

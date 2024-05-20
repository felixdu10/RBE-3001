%% Setup robot
travelTime = 2; % Defines the travel time
robot = Robot(); % Creates robot object
robot.writeTime(travelTime); % Write travel time
robot.writeMotorState(true); % Write position mode
%% Program 

robot.writeJoints(0); % Write joints to zero position
pause(travelTime); % Wait for trajectory completion

baseWayPoints = transpose([[-45, 20, -10, 0]; [45, 20, 10, 15]; [0, 0, 0, 0]]); % Define base waypoints

for baseWayPoint = baseWayPoints % Iterate through waypoints

    robot.writeJoints(baseWayPoint); % Write joint values

    tic; % Start timer

    while toc < travelTime
        disp(robot.getJointsReadings()); % Read joint values
    end

end

robot.writeGripper(false);

pause(1);

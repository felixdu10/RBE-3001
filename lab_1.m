%% Setup robot
travelTime = 2; % Defines the travel time
robot = Robot(); % Creates robot object
robot.writeTime(travelTime); % Write travel time
robot.writeMotorState(true); % Write position mode
%% Program 

robot.set_joint_vars([0 0 0 0], travelTime); % Write joints to zero position
pause(travelTime); % Wait for trajectory completion
    
baseWayPoint = [30 40 -30 -50];

% Pre-allocate arrays for speed (200 is a rough number determined
% experimentally)
positions = zeros(200, 4);
times = zeros(200, 1);
index = 1;

robot.set_joint_vars(baseWayPoint); % Write joint values

tic; % Start timer

while toc < travelTime
    joints = robot.read_joint_vars(true, false);
    disp(joints); % Read joint values

    % Save positions and times
    positions(index, :) = joints(1, :);
    times(index, 1) = toc*1000; % time in ms
    
    index = index+1;
end
% concatenate times on left side of positions
result = [times positions];
result(index:end, :) = []; % trim zeroes off of the end
writematrix(result, "pose3.csv");
robot.writeGripper(false);

pause(1);

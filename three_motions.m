close all
%% Setup robot
travelTime = 3; % Defines the travel time
robot = Robot(); % Creates robot object
robot.writeTime(travelTime); % Write travel time
robot.writeMotorState(true); % Write position mode
%% Program 

robot.set_joint_vars([0 0 0 0], travelTime); % Write joints to zero position
pause(travelTime); % Wait for trajectory completion

% Arrays to store results of runs
run1 = [];
run2 = [];
run3 = [];

startPos = 0;
endPos = 60;

for run = 1:3 % Complete the motion three times
    % Pre-allocate arrays for speed (200 is a rough number determined
    % experimentally)
    positions = zeros(200, 4);
    times = zeros(200, 1);
    index = 1;

    robot.set_joint_vars([endPos 0 0 0]); % Write joint values

    tic; % Start timer

    % Save joints and timestamps while running
    while toc < travelTime
        joints = robot.read_joint_vars(true, false);
        disp(joints); % Read joint values
   
        % Save positions and times
        positions(index, :) = joints(1, :);
        times(index, 1) = toc*1000; % time in ms
        
        index = index+1;
    end

    % Send back to zero for the next run and start timer
    robot.set_joint_vars([0, 0, 0, 0]);
    tic;

    % concatenate times on left side of positions
    result = [times positions];
    result(index:end, :) = []; % trim zeroes off of the end

    % Save information for later graphing
    switch run
        case 1
            run1 = result;
            writematrix(result, "run1.csv", 'WriteMode', 'overwrite');
        case 2
            run2 = result;
            writematrix(result, "run2.csv", 'WriteMode', 'overwrite');
        case 3
            run3 = result;
            writematrix(result, "run3.csv", 'WriteMode', 'overwrite');
    end

    % Wait for motion to 0 to finish
    while(toc < travelTime)
    end
end

% Plot the runs on one graph
hold on
plot(run1(:, 1), run1(:, 2))
plot(run2(:, 1), run2(:, 2))
plot(run3(:, 1), run3(:, 2))
title('Position of joint over three runs 0-60 degrees in 3 seconds')
ylabel('Position (degrees)')
xlabel('Time (ms)')
legend('Run 1', 'Run 2', 'Run 3')
hold off

robot.writeGripper(false);

pause(1);

close all;
data = readmatrix("pose4.csv");
times = data(:, 1);

% Create figure with 4 sub-plots
sgtitle('Joint movements to pose 4 (-60 -55 -25 60)')
% Each joint gets one subplot, indexed by its joint number
for jointIndex = 1:4
    subplot(2, 2, jointIndex)
    x = times;
    y = data(:, jointIndex + 1); % Column 1 is times, column 2 is joint 1
    plot(x, y);

    title('Joint ' + string(jointIndex) + ' Position over time')
    xlabel('Time (ms)')
    ylabel('Position (degrees)')
    ylim([-90 90])
    xlim([0 times(end)])
end

% Create second figure for histogram
figure() 

timeSize = size(times) - 1; % subtract one to not overflow

% Create array to store differences between subsequent times
timeIntervals = zeros(timeSize - 1);

% Calculate the interval between each reading
for timeIndex = 1 : timeSize(1) 
    timeIntervals(timeIndex) = times(timeIndex + 1) - times(timeIndex);
end

% Plot histogram
histogram(timeIntervals);
title('Time intervals between readings');
xlabel('Time interval (ms)');
ylabel('Frequency');

% Display statistics
disp("Time step data:")
disp("Mean: " + +mean(timeIntervals) + "ms, median: " + +median(timeIntervals) + "ms")
disp("Minimum: " + +min(timeIntervals) + "ms, max: " + +max(timeIntervals) + "ms")

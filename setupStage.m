function fig = setupStage(xAxisNeg, xAxisPos, yAxisNeg, yAxisPos)
% This function sets up the figure with stage
% the function, must be on a folder in matlab path
% xAxisNeg is the min leftmost x-axis of the stage
% xAxisPos is the max rightmost x-axis of the stage
% yAxisNeg is the min bottom of y-axis of the stage
% yAxisPos is the max top of y-axis of the stage

    fig = figure(1); clf;
    set(gcf, 'Position', [0, 0, 800, 800]); % resize the stage
    movegui(fig,'northeast'); % position the stage
    axis([xAxisNeg xAxisPos yAxisNeg yAxisPos])
    set(gca,'Color','k')
    grid on
    title('Simulation World (in meters)')
    hold on
end
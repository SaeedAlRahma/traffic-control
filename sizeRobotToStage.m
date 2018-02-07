function sizeRobotToStage(robots, radius)
% This function resizes the robots shape on figure
% the function, must be on a folder in matlab path
% robots is a matrix of robots locations
% radius is the robot radius

    currentunits = get(gca,'Units');
    set(gca, 'Units', 'Points');
    axpos = get(gca,'Position');
    set(gca, 'Units', currentunits);
    markerWidth = (radius.*2)/diff(xlim)*axpos(3);
    set(robots, 'SizeData', markerWidth^2)

end
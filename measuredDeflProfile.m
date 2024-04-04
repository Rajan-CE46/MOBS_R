function measuredDeflProfile(RC, DEFL)
    % Multiply DEFL by -1000 to convert to mils
    DEFL = DEFL * -1000;

    % Plot the deflection profile
    plot(RC, DEFL, 'o-');
    
    xlabel('Radial Coordinate in inches','FontSize', 10);
    ylabel('Deflection in mils','FontSize', 10);
    
    ax = gca;

    % Increase the font size of the axis values (ticks)
    ax.FontSize = 12;  %
    ax.LineWidth = 0.8;

    % Set the figure size
    fig = gcf;
    fig.Position(3) = 550;  % Set width to 700
    fig.Position(4) = 250;  % Set height to 300

    % Save the figure as an image
    saveas(fig,'distVsDefl.png');
    close(fig);  % Close the figure to release resources
end

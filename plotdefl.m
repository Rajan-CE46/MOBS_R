function plotdefl(RC_ex,DEFL_ex,RC_es,DEFL_es)
    
    DEFL_ex = DEFL_ex * -1000;
    DEFL_es = DEFL_es * -1000;

    
    plot(RC_ex, DEFL_ex, 'o-', RC_es, DEFL_es, '*-', 'LineWidth', 1.5);
    
    % Add legend at bottom right
    % legend('Experimental Data', 'Estimated Data', 'Location', 'southoutside');
    legend('Experimental Data', 'Estimated Data', 'Location', 'southeast', 'Orientation', 'vertical');

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

    saveas(fig, 'esVsEx.png');
    close(fig);
    
end

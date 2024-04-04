function plotdeflAll(RC_ex, DEFL_ex, DEFL_es_all, l, r)
    
    DEFL_ex = DEFL_ex * -1000;
    DEFL_es_all = DEFL_es_all * -1000;

    % Plot Experimental Data
    plot(RC_ex, DEFL_ex, 'o-', 'LineWidth', 1.5);
    hold on;  % Hold the plot for adding Estimated Data
    
    % Plot Estimated Data for each row
    for i = l:r
        plot(RC_ex, DEFL_es_all(i-l+1, :), '*-', 'LineWidth', 1.5);
        hold on;
    end
    
    % Add legend with numbers starting from l to r
    legend_str = {'Experimental Data'};
    for i = l:r
        legend_str{end+1} = ['Estimated Data ' num2str(i)];
    end
    legend(legend_str, 'Location', 'southeast', 'Orientation', 'vertical');
    
    xlabel('Radial Coordinate in inches','FontSize', 10);
    ylabel('Deflection in mils','FontSize', 10);
    
    ax = gca;
    ax.FontSize = 12;  % Increase the font size of the axis values (ticks)
    ax.LineWidth = 0.8;

    fig = gcf;
    fig.Position(3) = 550;  % Set width
    fig.Position(4) = 250;  % Set height

    saveas(fig, 'esVsExAll.png');
    close(fig);
    
end

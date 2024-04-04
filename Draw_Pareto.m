function [state, options, optchanged] = Draw_Pareto(options,state,flag)
    flag = flag;
    optchanged = false;
    currentScore = state.Score;
    % plot(fval(:,1), fval(:,2), );
    plot(currentScore(:,1), currentScore(:,2),'bo', 'Marker', 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
    drawnow;
end
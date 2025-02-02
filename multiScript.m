function errorFound = multiScript(numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err)
    
    rng(RNGSEEDER,'twister');    
    lb = LB;
    ub = UB;    
    objfcn = @(x) Multi_Objective_Fn(x, DEFL, TH, RC,PR,ZC,CR,STRESS);    
    nvars = numOfLayers;
    options = optimoptions(@gamultiobj,'OutputFcn',@Draw_Pareto,'populationSize',POP,'maxgen',GENS);
    [x,fval] = gamultiobj(objfcn,nvars,[],[],[],[],lb,ub,[],options);    

    rmse_avg = zeros(size(x, 1),1);
    
    % # Forward Calculation for avg_rms : 
    for i = 1:size(x, 1)
        NL = length(TH) + 1;          
        NZ = length(ZC);
        NR = length(RC);                    
        cinit = x(i, :);
        Etcur = cinit(1);
        Eunbound = cinit(2:end);
        finalDefOut = f_calc_unit_response_chev(NL, NZ, TH, PR, ZC, CR, STRESS, NR, RC, length(Etcur), Eunbound, Etcur);
        rmse = ((sum(((finalDefOut-DEFL)./DEFL).^2))/length(DEFL))^0.5*100;
        rmse_avg(i,1) = rmse;
    end
    
    finOutput = [x,fval,rmse_avg];
      
    hold on;
    plot(fval(:,1), fval(:,2), 'ro', 'Marker', 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 7);
    xlabel('f1-rmse1-minimized', 'FontSize', 22);
    ylabel('f2-rmse2-minimized', 'FontSize', 22);

   

    ax = gca;

    % Increase the font size of the axis values (ticks)
    ax.FontSize = 22;  %
    ax.LineWidth = 2;
    fig = gcf;
    fig.Position(3) = 950;  % Set width to 700
    fig.Position(4) = 550;  % Set height to 300
   
    saveas(fig, 'currentPareto.png');
    saveas(fig,'currentPareto1.png')

    % figName = ['Plot_multiobjOutput-' nameDifferentiator '-(' num2str(POP,'%02d') ',' num2str(GENS,'%02d') ').png'];
    folderPath = '../MULTI_OBJ_GA-OUTPUTS/';
    
    % Create the folder if it doesn't exist
    if ~isfolder(folderPath)
        mkdir(folderPath);
    end    
    
    % saveas(fig, fullfile(folderPath, figName));
    
    close(fig); % Close figure to prevent displaying it
  
    save('backCalRes',"finOutput");
    

    % Common part of var_names
    var_names_common = {'RMSE_1(%)', 'RMSE_2(%)', 'RMSE_AVG(%)'};
    
    % Generate the 'E' values based on nvars
    var_names_E = cell(1, nvars);
    for i = 1:nvars
        var_names_E{i} = ['E', num2str(i), '_estimated'];
    end
    
    % Combine common and 'E' values
    var_names = [var_names_E, var_names_common];
    
    % disp(var_names);
    serial_numbers = (1:size(finOutput, 1)).';

    % Append the serial numbers column to the data
    finOutputWithSerial = [serial_numbers, finOutput];
    T = array2table(finOutputWithSerial, 'VariableNames', ['Solution ID', var_names]);
  

    file_name = 'currentRes.xlsx';  % Specify the name of the file

    if exist(file_name, 'file') == 2  % Check if the file exists
        delete(file_name);  % Delete the file if it exists
    end
    writetable(T,'currentRes.xlsx');
    second_sheet_data = {
        'No. of Layers', num2str(numOfLayers);
        'Radial Distances', num2str(RC);
        'Deflection Values', num2str(DEFL);
        'Lower Limits', num2str(LB);
        'Upper Limits', num2str(UB);
        'Layer Thickness',num2str(TH);
        'Contact Radius',num2str(CR);
        'Contact Pressure',num2str(STRESS);
        'Poissons Ratios', num2str(PR);
        'ZC',num2str(ZC);
        'Number of Populations',num2str(POP);
        'Number of Generations',num2str(GENS);
        'RNG Seed',num2str(RNGSEEDER);
        'File Name',nameDifferentiator;        
        'Error Threshold',num2str(threshold_err)
        % Add more rows as needed
    };

% Create a table for the second sheet data
T_second_sheet = cell2table(second_sheet_data, 'VariableNames', {'Variable_Name', 'Value'});

% Write the second sheet data to the Excel file
writetable(T_second_sheet, 'currentRes.xlsx', 'Sheet', 2);
    
    python_command = 'python insertImageInExcel-Fin.py';
    system(python_command);        
    originalFilePath = 'currentRes.xlsx';
    folderPath = '../MULTI_OBJ_GA-OUTPUTS/';
    outputName = ['BackCalculationResult-' nameDifferentiator '-(' num2str(POP,'%02d') ',' num2str(GENS,'%02d') ').xlsx'];    
    outputFilePath = fullfile(folderPath, outputName);    
    
    % Copy the Excel file to the destination directory with the new name
    copyfile(originalFilePath, outputFilePath);


    e1_min = min(fval(:,1)); 
    e2_min = min(fval(:,2)); 

    if e1_min <= threshold_err && e2_min <= threshold_err
        errorFound = 0;
    elseif e1_min > threshold_err
        errorFound = 1;
    elseif e2_min > threshold_err
        errorFound = 2;
    end

    close all;           
end



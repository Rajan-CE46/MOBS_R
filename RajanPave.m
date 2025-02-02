classdef RajanPave < matlab.apps.AppBase
    properties (Access = public)
        UIFigure             matlab.ui.Figure 
        UIFigure2            matlab.ui.Figure


        StartWindow          matlab.ui.Figure
        Image                matlab.ui.control.Image
        HeroImg              matlab.ui.control.Image
        AcknowledgmentText   matlab.ui.control.Label
        
        MainAppUI            matlab.ui.Figure

        acnButton            matlab.ui.control.Button

        loadButton           matlab.ui.control.Button
        loadButton1          matlab.ui.control.Button

        PlotButton           matlab.ui.control.Button
        BackCalculate        matlab.ui.control.Button
        BackCalculate1       matlab.ui.control.Button
        checkForFaultySensor matlab.ui.control.Button
        changeUnit           matlab.ui.control.Button
        RemoveFaultedSensor  matlab.ui.control.Button
        checkDeflProfile     matlab.ui.control.Button
        checkDeflProfies     matlab.ui.control.Button
        UIAxes1              matlab.ui.control.UIAxes
        UIAxes2              matlab.ui.control.UIAxes
        UIAxesBackground     matlab.ui.control.UIAxes
        UIpave               matlab.ui.control.UIAxes
        ResTable             matlab.ui.control.Table
        UITextArea           matlab.ui.control.TextArea
        UITextArea2          matlab.ui.control.TextArea
        HelpButton           matlab.ui.control.Button
        StartButton          matlab.ui.control.Button
        layersCnt = matlab.ui.control.EditField;
        RCEditField = matlab.ui.control.EditField;
        DEFLEditField = matlab.ui.control.EditField ;       
        LBEditField = matlab.ui.control.EditField;
        UBEditField = matlab.ui.control.EditField;
        THEditField = matlab.ui.control.EditField ;
        PREditField = matlab.ui.control.EditField ;
        ZCEditField = matlab.ui.control.EditField ;
        CREditField = matlab.ui.control.EditField ;
        StressEditField = matlab.ui.control.EditField; 
        PopEditField = matlab.ui.control.EditField ;
        GensEditField = matlab.ui.control.EditField ;
        RNGSeederEditField = matlab.ui.control.EditField; 
        NameEditField = matlab.ui.control.EditField ;
        ThresholdEditField = matlab.ui.control.EditField;  
        SolIdEditField = matlab.ui.control.EditField ;
        SolIdLB = matlab.ui.control.EditField ;
        SolIdUB = matlab.ui.control.EditField ;


        softName = matlab.ui.control.Label;
        inputLabel = matlab.ui.control.Label;
        resultLabel =matlab.ui.control.Label;
        layerCntLabel = matlab.ui.control.Label;
        deflPlotLabel = matlab.ui.control.Label;
        paretoLabel = matlab.ui.control.Label;
        RCLabel = matlab.ui.control.Label;
        toLabel = matlab.ui.control.Label;
        unitDropdownRc          matlab.ui.control.DropDown
        unitDropdownResult      matlab.ui.control.DropDown

        DEFLLabel = matlab.ui.control.Label;
        unitDropdownDefl        matlab.ui.control.DropDown
        LBLabel = matlab.ui.control.Label;
        unitDropdownLb          matlab.ui.control.DropDown
        UBLabel = matlab.ui.control.Label;
        unitDropdownUb          matlab.ui.control.DropDown
        THELabel = matlab.ui.control.Label;
        unitDropdownTH          matlab.ui.control.DropDown
        PRELabel = matlab.ui.control.Label;
        ZCLabel = matlab.ui.control.Label;
        CRLabel = matlab.ui.control.Label;
        unitDropdownCR          matlab.ui.control.DropDown
        StressLabel = matlab.ui.control.Label;
        unitDropdownStress      matlab.ui.control.DropDown
        PopLabel = matlab.ui.control.Label;
        GensLabel = matlab.ui.control.Label;
        RNGSeederLabel = matlab.ui.control.Label;
        NameLabel = matlab.ui.control.Label;
        ThresholdLabel = matlab.ui.control.Label;
        ResultPoints = matlab.ui.control.Label;
        SolIdLabel = matlab.ui.control.Label;
        SOlIdRangeLabel = matlab.ui.control.Label;
        status = -1;
        faultySensor = -1;
        ranBackCal = 0;
        executionStatusLabel = matlab.ui.control.Label
        isloded = 0;
        mainLodedData;
        numOfLayers;
        TH_Batch;
        RC_Batch;
        DEFL_Batch;
        LB_Batch;
        UB_Batch;
        PR_Batch;
        ZC_Batch;
        CR_Batch;
        STRESS_Batch;
        POP_Batch;
        GENS_Batch;
        RNGSEEDER_Batch;
        nameDifferentiatorBatch;
        threshold_err_Batch;
    end


    % Callbacks that handle component events
    methods (Access = private)
        function PlotButtonPushed(app, event)
            app.UITextArea2.Value = "RUNNING";
            app.UITextArea2.BackgroundColor = [0.6 0 0];
            % Get user input from text boxes
            RC = str2num(app.RCEditField.Value); 
            DEFL = str2num(app.DEFLEditField.Value); 
            
            measuredDeflProfile(RC,DEFL);
            im1 = imread('distVsDefl.png');
           
            imshow(im1, 'Parent', app.UIAxes1);  
            
            app.UITextArea2.Value = "IDLE";
            app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];

        end

        function StartButtonPushed(app, event)
          % Hide the start window
            app.StartWindow.Visible = 'off';

            % Show the main app window
            app.UIFigure.Visible = 'on';
        end

        function StartButtonBatchPushed(app, event)
          % Hide the start window
            app.StartWindow.Visible = 'off';

            % Show the main app window
            app.UIFigure2.Visible = 'on';
        end

        function changeUnitPushed(app, event)
            app.UITextArea2.Value = "RUNNING";
            app.UITextArea2.BackgroundColor = [0.6 0 0];
            if app.ranBackCal == 1
                multiplier = 1;
                switch app.unitDropdownResult.Value
                    case 'psi'
                        multiplier = 1; 
                    case 'mpa'
                        multiplier = 0.00689476;
                    case 'pa'
                        multiplier = 6894.76;
                end
                filename = 'currentRes.xlsx';  % Specify the path to your Excel file
                opts = detectImportOptions(filename);
                opts.VariableNamingRule = 'preserve';  % Set VariableNamingRule to preserve original column headers
                data = readtable(filename, opts);
                % if app.isloded == 1
                %    data = app.mainLodedData;
                % end
               
               
                disp(width(data))
                for col = 2:(width(data)-3)               
                    data{1:end,col} = data{1:end,col} * multiplier;  % Multiply the values in the specified column by 5
                end
                app.ResTable.Data = data;
            else
                msg = "First Run Back Calculation :<";
                title = 'Message';
                msgbox(msg, title);
            end

            app.UITextArea2.Value = "IDLE";
            app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];

        end

        function helpButtonPushed(app, event)
            % Define the Google Drive link to your PDF file
            pdfURL = 'https://drive.google.com/drive/folders/1EfR-V2e1EwPKPvO3vm0XJG8iWjVGaIKl?usp=sharing';

            % Open the PDF file in the default web browser
            web(pdfURL, '-browser');
        end

        function acnButtonPushed(app, event)
            % Define the Google Drive link to your PDF file
            pdfURL = 'https://drive.google.com/drive/folders/1EfR-V2e1EwPKPvO3vm0XJG8iWjVGaIKl?usp=sharing';

            % Open the PDF file in the default web browser
            web(pdfURL, '-browser');
        end

        function BackCalculatePushed(app,event)
            
           % app.isloded = 0;
           app.UITextArea2.Value = "RUNNING";
           app.UITextArea2.BackgroundColor = [0.6 0 0];
           
            
           RC = str2num(app.RCEditField.Value);
            switch app.unitDropdownRc.Value
                case 'inches'
                    RC = RC * 1; 
                case 'mm'
                    RC = RC * 0.0393701;
                case 'cm'
                    RC = RC * 0.393701;
                case 'mils'
                    RC = RC * 0.001;
            end

            DEFL = str2num(app.DEFLEditField.Value)
            switch app.unitDropdownDefl.Value
                case 'inches'
                    DEFL = DEFL * 1; 
                case 'mm'
                    DEFL = DEFL * 0.0393701;
                case 'cm'
                    DEFL = DEFL * 0.393701;
                case 'mils'
                    DEFL = DEFL * 0.001;
            end

            measuredDeflProfile(RC,DEFL);
            im1 = imread('distVsDefl.png');
            imshow(im1, 'Parent', app.UIAxes1)

            LB = str2num(app.LBEditField.Value)
            switch app.unitDropdownLb.Value
                case 'psi'
                    LB = LB * 1; 
                case 'mpa'
                    LB = LB * 145.038;
                case 'pa'
                    LB = LB * 0.000145038;
            end

            UB = str2num(app.UBEditField.Value)
            switch app.unitDropdownUb.Value
                case 'psi'
                    UB = UB * 1; 
                case 'mpa'
                    UB = UB * 145.038;
                case 'pa'
                    UB = UB * 0.000145038;
            end

            TH = str2num(app.THEditField.Value);
            switch app.unitDropdownTH.Value
                case 'inches'
                    TH = TH * 1; 
                case 'mm'
                    TH = TH * 0.0393701;
                case 'cm'
                    TH = TH * 0.393701;
                case 'mils'
                    TH = TH * 0.001;
            end
            PR = str2num(app.PREditField.Value)
            ZC = str2num(app.ZCEditField.Value)
            CR = str2num(app.CREditField.Value)
            switch app.unitDropdownCR.Value
                case 'inches'
                    CR = CR * 1; 
                case 'mm'
                    CR = CR * 0.0393701;
                case 'cm'
                    CR = CR * 0.393701;
                case 'mils'
                    CR = CR * 0.001;
            end
            Stress = str2num(app.StressEditField.Value)
            switch app.unitDropdownStress.Value
                case 'psi'
                    Stress = Stress * 1; 
                case 'mpa'
                    Stress = Stress * 145.038;
                case 'pa'
                    Stress = Stress * 0.000145038;
            end
            
            Pop = str2num(app.PopEditField.Value)
            Gens = str2num(app.GensEditField.Value)
            RNGSeeder = str2num(app.RNGSeederEditField.Value)
            Name = app.NameEditField.Value
            Threshold = str2num(app.ThresholdEditField.Value)
            numOfLayers = str2num(app.layersCnt.Value)
            disp(LB);
            % disp(dsfljh);
            x = main_single(-1,-1,numOfLayers,TH,RC, DEFL, LB, UB, PR, ZC, CR, Stress, Pop, Gens, RNGSeeder, Name, Threshold);
            app.status = x;
            
            im2 = imread('currentPareto.png');
            imshow(im2,'Parent',app.UIAxes2);

           
            filename = 'currentRes.xlsx';  % Specify the path to your Excel file
            opts = detectImportOptions(filename);
            opts.VariableNamingRule = 'preserve';  % Set VariableNamingRule to preserve original column headers
            data = readtable(filename, opts);
            app.unitDropdownResult.Value = 'psi';
            app.ResTable.Data = data;
            app.ranBackCal = 1;
            app.UITextArea2.Value = "IDLE";
            app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];
        end
    
        function checkForFaultySensorPushed(app, event)
            % Get user input from text boxes
            % Define the file paths for both the source and destination Excel files
            sourceFilePath = 'currentRes.xlsx';  % Specify the path to your source Excel file
            destFilePath = 'currentResDummyForFaulty.xlsx';  % Specify the path to your destination Excel file
            
             if exist(destFilePath, 'file')
                delete(destFilePath);
                disp('Existing Excel file deleted.');
            end
            
            
            % Create a copy of the Excel file using copyfile
            copyfile(sourceFilePath, destFilePath);

            app.UITextArea2.Value = "RUNNING";
            app.UITextArea2.BackgroundColor = [0.6 0 0];
            RC = str2num(app.RCEditField.Value); 
            switch app.unitDropdownRc.Value
                case 'inches'
                    RC = RC * 1; 
                case 'mm'
                    RC = RC * 0.0393701;
                case 'cm'
                    RC = RC * 0.393701;
                case 'mils'
                    RC = RC * 0.001;
            end

            DEFL = str2num(app.DEFLEditField.Value);
            switch app.unitDropdownDefl.Value
                case 'inches'
                    DEFL = DEFL * 1; 
                case 'mm'
                    DEFL = DEFL * 0.0393701;
                case 'cm'
                    DEFL = DEFL * 0.393701;
                case 'mils'
                    DEFL = DEFL * 0.001;
            end
            LB = str2num(app.LBEditField.Value);
            switch app.unitDropdownLb.Value
                case 'psi'
                    LB = LB * 1; 
                case 'mpa'
                    LB = LB * 145.038;
                case 'pa'
                    LB = LB * 0.000145038;
            end

            UB = str2num(app.UBEditField.Value);
            switch app.unitDropdownUb.Value
                case 'psi'
                    UB = UB * 1; 
                case 'mpa'
                    UB = UB * 145.038;
                case 'pa'
                    UB = UB * 0.000145038;
            end

            TH = str2num(app.THEditField.Value);
            switch app.unitDropdownTH.Value
                case 'inches'
                    TH = TH * 1; 
                case 'mm'
                    TH = TH * 0.0393701;
                case 'cm'
                    TH = TH * 0.393701;
                case 'mils'
                    TH = TH * 0.001;
            end
            PR = str2num(app.PREditField.Value);
            ZC = str2num(app.ZCEditField.Value);
            CR = str2num(app.CREditField.Value);
            switch app.unitDropdownCR.Value
                case 'inches'
                    CR = CR * 1; 
                case 'mm'
                    CR = CR * 0.0393701;
                case 'cm'
                    CR = CR * 0.393701;
                case 'mils'
                    CR = CR * 0.001;
            end
            Stress = str2num(app.StressEditField.Value);
            switch app.unitDropdownStress.Value
                case 'psi'
                    Stress = Stress * 1; 
                case 'mpa'
                    Stress = Stress * 145.038;
                case 'pa'
                    Stress = Stress * 0.000145038;
            end

            Pop = str2num(app.PopEditField.Value);
            Gens = str2num(app.GensEditField.Value);
            RNGSeeder = str2num(app.RNGSeederEditField.Value);
            Name = app.NameEditField.Value;
            Threshold = str2num(app.ThresholdEditField.Value);  
            numOfLayers = str2num(app.layersCnt.Value);
           
            y = main_single(0,-1,numOfLayers,TH,RC, DEFL, LB, UB, PR, ZC, CR, Stress, Pop, Gens, RNGSeeder, Name, Threshold);
            app.faultySensor = y;
            directoryPath = '../MULTI_OBJ_GA-OUTPUTS/';
            nameDifferentiator = Name;  % Replace with your differentiator
            fileName = ['output-', nameDifferentiator, '.txt'];
            fullFilePath = fullfile(directoryPath, fileName);
            if exist(fullFilePath, 'file') == 2
                fileContent = fileread(fullFilePath);
                app.UITextArea.Value = fileContent;
            else
                app.UITextArea.Value = 'File not found.';
            end
            
            sourceFilePath = 'currentResDummyForFaulty.xlsx';  % Specify the path to your source Excel file
            destFilePath = 'currentRes.xlsx';  % Specify the path to your destination Excel file
            
           if exist(destFilePath, 'file')
                delete(destFilePath);
                disp('Existing Excel file deleted.');
            end
            
            % Copy the source Excel file to the destination location
            copyfile(sourceFilePath, destFilePath);
            % app.isloded = 0;
             app.UITextArea2.Value = "IDLE";
             app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];
            
        end

        function RemoveFaultedSensorPushed(app, event)   
            app.UITextArea2.Value = "RUNNING";
            app.UITextArea2.BackgroundColor = [0.6 0 0];
            RC = str2num(app.RCEditField.Value); 
            switch app.unitDropdownRc.Value
                case 'inches'
                    RC = RC * 1; 
                case 'mm'
                    RC = RC * 0.0393701;
                case 'cm'
                    RC = RC * 0.393701;
                case 'mils'
                    RC = RC * 0.001;
            end

            DEFL = str2num(app.DEFLEditField.Value);
            switch app.unitDropdownDefl.Value
                case 'inches'
                    DEFL = DEFL * 1; 
                case 'mm'
                    DEFL = DEFL * 0.0393701;
                case 'cm'
                    DEFL = DEFL * 0.393701;
                case 'mils'
                    DEFL = DEFL * 0.001;
            end
            LB = str2num(app.LBEditField.Value);
            switch app.unitDropdownLb.Value
                case 'psi'
                    LB = LB * 1; 
                case 'mpa'
                    LB = LB * 145.038;
                case 'pa'
                    LB = LB * 0.000145038;
            end

            UB = str2num(app.UBEditField.Value);
            switch app.unitDropdownUb.Value
                case 'psi'
                    UB = UB * 1; 
                case 'mpa'
                    UB = UB * 145.038;
                case 'pa'
                    UB = UB * 0.000145038;
            end

            TH = str2num(app.THEditField.Value);
            switch app.unitDropdownTH.Value
                case 'inches'
                    TH = TH * 1; 
                case 'mm'
                    TH = TH * 0.0393701;
                case 'cm'
                    TH = TH * 0.393701;
                case 'mils'
                    TH = TH * 0.001;
            end
            PR = str2num(app.PREditField.Value);
            ZC = str2num(app.ZCEditField.Value);
            CR = str2num(app.CREditField.Value);
            switch app.unitDropdownCR.Value
                case 'inches'
                    CR = CR * 1; 
                case 'mm'
                    CR = CR * 0.0393701;
                case 'cm'
                    CR = CR * 0.393701;
                case 'mils'
                    CR = CR * 0.001;
            end
            Stress = str2num(app.StressEditField.Value);
            switch app.unitDropdownStress.Value
                case 'psi'
                    Stress = Stress * 1; 
                case 'mpa'
                    Stress = Stress * 145.038;
                case 'pa'
                    Stress = Stress * 0.000145038;
            end
            Pop = str2num(app.PopEditField.Value);
            Gens = str2num(app.GensEditField.Value);
            RNGSeeder = str2num(app.RNGSeederEditField.Value);
            Name = app.NameEditField.Value;
            Threshold = str2num(app.ThresholdEditField.Value);      
            numOfLayers = str2num(app.layersCnt.Value);
            if app.faultySensor ~= -1 && app.faultySensor ~= -2
                % app.isloded = 0;
                main_single(-1,app.faultySensor,numOfLayers,TH,RC, DEFL, LB, UB, PR, ZC, CR, Stress, Pop, Gens, RNGSeeder, Name, Threshold);
                im2 = imread('currentPareto.png');
                imshow(im2,'Parent',app.UIAxes2);
    
                filename = 'currentRes.xlsx';  % Specify the path to your Excel file
                opts = detectImportOptions(filename);
                opts.VariableNamingRule = 'preserve';  % Set VariableNamingRule to preserve original column headers
                data = readtable(filename, opts);
                app.unitDropdownResult.Value = 'psi';
                app.ResTable.Data = data;   
                
            elseif app.faultySensor == -2
                msg = "Could not found Faulted Sensor corresponding to thresold value :)";
                title = 'Message';
                msgbox(msg, title);
            else
                msg = "First Check for Faulty Sensor";
                title = 'Message';
                msgbox(msg, title);
            end
            app.UITextArea2.Value = "IDLE";
            app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];

            
        end

        function checkDeflProfilePushed(app, ~)
            app.UITextArea2.Value = "RUNNING";
            app.UITextArea2.BackgroundColor = [0.6 0 0];
            if app.ranBackCal == 1
                % Get user input from text boxes
                RC_ex = str2num(app.RCEditField.Value); 
                DEFL_ex = str2num(app.DEFLEditField.Value);
                SolID = str2num(app.SolIdEditField.Value); 
                disp(RC_ex);
                TH = str2num(app.THEditField.Value);
                switch app.unitDropdownTH.Value
                    case 'inches'
                        TH = TH * 1; 
                    case 'mm'
                        TH = TH * 0.0393701;
                    case 'cm'
                        TH = TH * 0.393701;
                    case 'mils'
                        TH = TH * 0.001;
                end
                PR = str2num(app.PREditField.Value);
                ZC = str2num(app.ZCEditField.Value);
                CR = str2num(app.CREditField.Value);
                switch app.unitDropdownCR.Value
                    case 'inches'
                        CR = CR * 1; 
                    case 'mm'
                        CR = CR * 0.0393701;
                    case 'cm'
                        CR = CR * 0.393701;
                    case 'mils'
                        CR = CR * 0.001;
                end
                CR = str2num(app.CREditField.Value);
    
                STRESS = str2num(app.StressEditField.Value);
                 switch app.unitDropdownStress.Value
                    case 'psi'
                        STRESS = STRESS * 1; 
                    case 'mpa'
                        STRESS = STRESS * 145.038;
                    case 'pa'
                        STRESS = STRESS * 0.000145038;
                end
                % Specify the Excel file name
                filename = 'currentRes.xlsx';
                
                % Specify the sheet name (if applicable)
                sheet = 'Sheet1';  % Update with your sheet name if different
                
                % Specify the row number (nth row) you want to read
                n = str2num(app.SolIdEditField.Value);  % Update with the desired row number
                
                % Read the data from the Excel file
                data = app.ResTable.Data;
                data = xlsread(filename, sheet);
                
                disp(data);
                % disp(size(data,1))
                if n > size(data,1) || n == 0
                   
                    msg = "Enter Valid solution ID";
                    title = 'Message';
                    msgbox(msg, title);
                else
                    % Extract the first three columns of the nth row and save them into an array
                    
                    % disp(E_est);
                    NL = length(TH) + 1;          
                    NZ = length(ZC);
                    NR = length(RC_ex); 
                    E_est = data(n, 2:NL+1);
                    cinit = E_est;
                    Etcur = cinit(1);
                    Eunbound = cinit(2:end);
                    DEFL_es = f_calc_unit_response_chev(NL, NZ, TH, PR, ZC, CR, STRESS, NR, RC_ex, length(Etcur), Eunbound, Etcur);
                    
                              
                    plotdefl(RC_ex,DEFL_ex,RC_ex,DEFL_es);
                    im1 = imread('esVsEx.png');
                   
                    imshow(im1, 'Parent', app.UIAxes1);           
                end
            else
                msg = "First Run Back Calculation :<";
                title = 'Message';
                msgbox(msg, title);

            end

            app.UITextArea2.Value = "IDLE";
            app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];
        end

        function checkDeflProfilesPushed(app, event)
            app.UITextArea2.Value = "RUNNING";
            app.UITextArea2.BackgroundColor = [0.6 0 0];
            if app.ranBackCal == 1
                 % Get user input from text boxes
                RC_ex = str2num(app.RCEditField.Value); 
                DEFL_ex = str2num(app.DEFLEditField.Value);
                SolID = str2num(app.SolIdEditField.Value); 
                 TH = str2num(app.THEditField.Value);
                switch app.unitDropdownTH.Value
                    case 'inches'
                        TH = TH * 1; 
                    case 'mm'
                        TH = TH * 0.0393701;
                    case 'cm'
                        TH = TH * 0.393701;
                    case 'mils'
                        TH = TH * 0.001;
                end
                PR = str2num(app.PREditField.Value);
                ZC = str2num(app.ZCEditField.Value);
                CR = str2num(app.CREditField.Value);
                switch app.unitDropdownCR.Value
                    case 'inches'
                        CR = CR * 1; 
                    case 'mm'
                        CR = CR * 0.0393701;
                    case 'cm'
                        CR = CR * 0.393701;
                    case 'mils'
                        CR = CR * 0.001;
                end
                CR = str2num(app.CREditField.Value);
    
                STRESS = str2num(app.StressEditField.Value);
                 switch app.unitDropdownStress.Value
                    case 'psi'
                        STRESS = STRESS * 1; 
                    case 'mpa'
                        STRESS = STRESS * 145.038;
                    case 'pa'
                        STRESS = STRESS * 0.000145038;
                end
                
                filename = 'currentRes.xlsx';
                
                % Specify the sheet name (if applicable)
                sheet = 'Sheet1';  % Update with your sheet name if different
                
                % Specify the row number (nth row) you want to read
                l = str2num(app.SolIdLB.Value);  % Update with the desired row number
                r = str2num(app.SolIdUB.Value);
                
                % Read the data from the Excel file
                data = app.ResTable.Data;
                data = xlsread(filename, sheet);
                disp(size(data,1))
               
                if r > size(data,1) || l == 0 || l > r
                    msg = "Enter Valid Solution ID Range";
                    title = 'Alert';
                    msgbox(msg, title);
                else
                    
                    NL = length(TH) + 1;
                    NZ = length(ZC);
                    NR = length(RC_ex);
                    E_est = data(l:r, 2:NL + 1);
                    
                    DEFL_es_all = zeros(r - l + 1, NR);  % Preallocate array to store DEFL_es for each row
                    
                    for i = 1:size(E_est, 1)
                        cinit = E_est(i, :);
                        Etcur = cinit(1);
                        Eunbound = cinit(2:end);
                        DEFL_es_all(i, :) = f_calc_unit_response_chev(NL, NZ, TH, PR, ZC, CR, STRESS, NR, RC_ex, length(Etcur), Eunbound, Etcur);
                    end
                    
                   
                    plotdeflAll(RC_ex,DEFL_ex,DEFL_es_all,l,r);
                    im1 = imread('esVsExAll.png');
                   
                    imshow(im1, 'Parent', app.UIAxes1);           
                end
            else
                msg = "First Run Back Calculation :<";
                title = 'Message';
                msgbox(msg, title);

            end
           
            app.UITextArea2.Value = "IDLE";
            app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];
        end
        
        function loadButtonPushed(app, ~)
            app.UITextArea2.Value = "RUNNING";
            app.UITextArea2.BackgroundColor = [0.6 0 0];

            % Check if the lastpath file exists and load it
            if exist('lastpath.mat', 'file') == 2
                load('lastpath.mat');
                lastFolder = lastpath;
            else
                lastFolder = pwd; % Set the default folder to the current working directory
            end
            
            % Open a file dialog for the user to select an Excel file
            [fileName, filePath] = uigetfile({'*.xlsx', 'Excel Files (*.xlsx)'}, 'Select Excel File', lastFolder);
            
            if fileName ~= 0 % Check if a file was selected
                % Combine the file path and name to get the full file path
                fullFilePath = fullfile(filePath, fileName);
                opts = detectImportOptions(fullFilePath);
                opts.VariableNamingRule = 'preserve';

                % Read the data from the Excel file using readtable
                data = readtable(fullFilePath, opts, 'Sheet', 'Sheet1'); % Specify the sheet name or index

                % Display the loaded data in the table component
                app.ResTable.Data = data;
                app.unitDropdownResult.Value = 'psi';
                app.unitDropdownStress.Value = 'psi';
                 app.unitDropdownCR.Value = 'inches';
                 app.unitDropdownTH.Value = 'inches';
                 app.unitDropdownUb.Value = 'psi';
                 app.unitDropdownLb.Value = 'psi';
                 app.unitDropdownDefl.Value = 'inches';
                  app.unitDropdownRc.Value = 'inches';
                app.mainLodedData = data;
                data2 = readcell(fullFilePath, 'Sheet', 'Sheet2');

                fval1 = data{:, 5}; % Extracting values from column 5
                fval2 = data{:, 6}; % Extracting values from column 6
                
                plot(fval1, fval2, 'ro', 'Marker', 'o', 'MarkerFaceColor', 'r', 'MarkerSize', 7);

                xlabel('f1-rmse1-minimized', 'FontSize', 22);
                ylabel('f2-rmse2-minimized', 'FontSize', 22);
            
               
            
                ax = gca;
            
                % Increase the font size of the axis values (ticks)
                ax.FontSize = 22;  %
                ax.LineWidth = 2;
                fig = gcf;
                fig.Position(3) = 950;  % Set width to 700
                fig.Position(4) = 550;  % Set height to 300
               
                saveas(fig, 'currentPareto3.png');
                close(fig);
               
                im1 = imread('currentPareto3.png');
                imshow(im1, 'Parent', app.UIAxes2);    

                % Extract the first 10 rows of the 2nd column
                extractedData = data2(2:16, 2);
               
                app.layersCnt.Value = string(extractedData{1});
                app.RCEditField.Value = string(extractedData{2});
                app.DEFLEditField.Value = string(extractedData{3});
                app.LBEditField.Value = string(extractedData{4});
                app.UBEditField.Value = string(extractedData{5});
                app.THEditField.Value = string(extractedData{6});
                app.PREditField.Value = string(extractedData{9});
                app.ZCEditField.Value = string(extractedData{10});
                app.CREditField.Value = string(extractedData{7});
                app.StressEditField.Value = string(extractedData{8});
                app.PopEditField.Value = string(extractedData{11});
                app.GensEditField.Value = string(extractedData{12});
                app.RNGSeederEditField.Value = string(extractedData{13});
                app.NameEditField.Value = string(extractedData{14});
                app.ThresholdEditField.Value = string(extractedData{15});

                RC = str2num(app.RCEditField.Value);
                switch app.unitDropdownRc.Value
                    case 'inches'
                        RC = RC * 1; 
                    case 'mm'
                        RC = RC * 0.0393701;
                    case 'cm'
                        RC = RC * 0.393701;
                    case 'mils'
                        RC = RC * 0.001;
                end
    
                DEFL = str2num(app.DEFLEditField.Value);
                switch app.unitDropdownDefl.Value
                    case 'inches'
                        DEFL = DEFL * 1; 
                    case 'mm'
                        DEFL = DEFL * 0.0393701;
                    case 'cm'
                        DEFL = DEFL * 0.393701;
                    case 'mils'
                        DEFL = DEFL * 0.001;
                end
    
                measuredDeflProfile(RC,DEFL);
                im1 = imread('distVsDefl.png');
                imshow(im1, 'Parent', app.UIAxes1)

                app.ranBackCal = 1;
                
                % app.isloded = 1;
                sourceFilePath = fullFilePath;  % Specify the path to your source Excel file
                destFilePath = 'currentRes.xlsx';  % Specify the path to your destination Excel file

                sourceAbsPath = sourceFilePath
                destAbsPath = fullfile(pwd, destFilePath)
                

                % Check if the source and destination paths are the same
               if isequal(sourceAbsPath, destAbsPath)
                    disp('Source and destination files are the same. File copy not required.');
                else
                    % Check if the destination file already exists
                    if exist(destFilePath, 'file')
                        delete(destFilePath);
                        disp('Existing Excel file deleted.');
                    end
                
                    % Copy the source Excel file to the destination location
                    copyfile(sourceFilePath, destFilePath);
                end

                    

                % try
                %     % Read the data from the Excel file using readtable or xlsread
                %     % For example, using readtable:
                %     % data = readtable(fullFilePath);
                %     opts = detectImportOptions(fullFilePath);
                %     opts.VariableNamingRule = 'preserve';
                % 
                %     % Read the data from the Excel file using readtable
                %     data = readtable(fullFilePath, opts, 'Sheet', 'Sheet1'); % Specify the sheet name or index
                % 
                %     % Display the loaded data in the table component
                %     app.ResTable.Data = data;
                %     data2 = readmatrix(fullFilePath, 'Sheet', 2);
                % 
                %     % Extract the first 10 rows of the 2nd column
                %     extractedData = data2(1:15, 2);
                %     disp(extractedData)
                % 
                %     app.before_layersCnt.Value = extractedData(1);
                %     app.before_RCEditField.Value = extractedData(2);
                %     app.before_DEFLEditField.Value = extractedData(3);
                %     app.before_LBEditField.Value = extractedData(4);
                %     app.before_UBEditField.Value = extractedData(5);
                %     app.before_THEditField.Value = extractedData(6);
                %     app.before_PREditField.Value = extractedData(7);
                %     app.before_ZCEditField.Value = extractedData(8);
                %     app.before_CREditField.Value = extractedData(9);
                %     app.before_StressEditField.Value = extractedData(10);
                %     app.PopEditField.Value = extractedData(11);
                %     app.GensEditField.Value =extractedData(12);
                %     app.RNGSeederEditField.Value =extractedData(13);
                %     app.NameEditField.Value =extractedData(14);
                %     app.ThresholdEditField.Value =extractedData(15);
                % 
                %     % Save the extracted data into separate variables var1, var2, ..., var10
                % 
                %     % Display the loaded data in the table component
                %     % app.dataTable.Data = data;
                % 
                %     % Display a message indicating successful loading
                %     msgbox('Data loaded successfully!', 'Success', 'modal');
                % 
                % catch ME
                %     % Display an error message if there's an issue loading the file
                %     errMessage = ['Error loading file: ', ME.message];
                %     errordlg(errMessage, 'File Load Error', 'modal');
                % end
            
            else
                disp('No file selected.'); % Display a message if no file is selected
            end

            app.UITextArea2.Value = "IDLE";
            app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];
           
        end

        function textFileFormat(app, event)
            % Define the Google Drive link to your PDF file
            pdfURL = 'https://drive.google.com/file/d/1q5BOrM55ow7P3ZXHTwakFtSVlDqAQDqD/view?usp=sharing';

            % Open the PDF file in the default web browser
            web(pdfURL, '-browser');
        end

        function inputtextPushed(app, ~)
            [fileName, filePath] = uigetfile({'*.txt', 'Text Files (*.txt)'}, 'Select Text File');
            fullFilePath = fullfile(filePath, fileName);
                
            if isequal(fileName,0) || isequal(filePath,0)
                disp('User canceled the dialog.');
            else
                % Call the readDataFromFile function with the selected file
                [numOfLayers,TH_Batch, RC_Batch, DEFL_Batch, LB_Batch, UB_Batch, PR_Batch, ...
                    ZC_Batch, CR_Batch, STRESS_Batch, POP_Batch, GENS_Batch, RNGSEEDER_Batch, ...
                    nameDifferentiatorBatch, threshold_err_Batch] = readDataFromFile(fullFilePath);
    
                app.numOfLayers = numOfLayers;
                app.TH_Batch = TH_Batch;
                app.RC_Batch = RC_Batch;
                app.DEFL_Batch = DEFL_Batch;
                app.LB_Batch = LB_Batch;
                app.UB_Batch = UB_Batch;
                app.PR_Batch = PR_Batch;
                app.ZC_Batch = ZC_Batch;
                app.CR_Batch = CR_Batch;
                app.STRESS_Batch = STRESS_Batch;
                app.POP_Batch = POP_Batch;
                app.GENS_Batch = GENS_Batch;
                app.RNGSEEDER_Batch = RNGSEEDER_Batch;
                app.nameDifferentiatorBatch = nameDifferentiatorBatch;
                app.threshold_err_Batch = threshold_err_Batch;  
            end

        end

        function BackCalculateBatchPushed(app,event)
            numOfLayers = app.numOfLayers;
            TH_Batch = app.TH_Batch;
            RC_Batch = app.RC_Batch;
            DEFL_Batch = app.DEFL_Batch;
            LB_Batch = app.LB_Batch;
            UB_Batch = app.UB_Batch;
            PR_Batch = app.PR_Batch;
            ZC_Batch = app.ZC_Batch;
            CR_Batch = app.CR_Batch;
            STRESS_Batch = app.STRESS_Batch;
            POP_Batch = app.POP_Batch;
            GENS_Batch = app.GENS_Batch;
            RNGSEEDER_Batch = app.RNGSEEDER_Batch;
            nameDifferentiatorBatch = app.nameDifferentiatorBatch;
            threshold_err_Batch = app.threshold_err_Batch;
            main_batch(numOfLayers,TH_Batch,RC_Batch,DEFL_Batch,LB_Batch, UB_Batch, PR_Batch, ZC_Batch, CR_Batch, STRESS_Batch, POP_Batch, GENS_Batch, RNGSEEDER_Batch,nameDifferentiatorBatch,threshold_err_Batch);
        end
    end

    
    % App initialization and construction
    methods (Access = private)
        % Create UIFigure and components
        function createComponents(app)
            screenSize = get(0, 'ScreenSize');
            % Calculate app position (100% width and height)
            appPosition = [screenSize(3)/2 - screenSize(3)/2, ...
                           screenSize(4)/2 - screenSize(4)/2, ...
                           screenSize(3), ...
                           screenSize(4)];

            app.UIFigure = uifigure('Name', 'RajanPave', 'Position', appPosition);
            app.UIFigure.Visible = 'off';

            app.StartWindow = uifigure('Visible', 'on');
            app.StartWindow.Position = appPosition;
            app.StartWindow.Name = 'StartWindow';

            % Create Image
            imageWidth = 150; % Width of the logo image
            imageHeight = 150; % Height of the logo image
            windowWidth = screenSize(3); % Width of the window
            windowHeight = screenSize(4); % Height of the window
            
            % Calculate the position to center the image
            imagePositionX = 420;
            imagePositionY = (windowHeight - imageHeight) / 6;
            
            % Create Image
            app.Image = uiimage(app.StartWindow);
            app.Image.Position = [imagePositionX, imagePositionY, imageWidth, imageHeight];
            app.Image.ImageSource = 'background_image.png';
            % Create AcknowledgmentText

            % app.HeroImg = uiimage(app.StartWindow);
            % app.HeroImg.Position = [490 230 500 500];
            % app.HeroImg.ImageSource = 'Surface-deflection-basin-from-the-FWD-test.png';

            
            app.softName = uilabel(app.StartWindow);
            app.softName.HorizontalAlignment = 'center';
            app.softName.FontSize = 35;
            app.softName.FontWeight = 'bold';
            app.softName.Position = [350 800 800 38];
            app.softName.Text = 'MOBS';

            app.softName = uilabel(app.StartWindow);
            app.softName.HorizontalAlignment = 'center';
            app.softName.FontSize = 30;
            app.softName.FontWeight = 'bold';
            app.softName.Position = [350 760 800 38];
            app.softName.Text = 'Multi Objective BackCalculation Software';


            % app.AcknowledgmentText = uilabel(app.StartWindow);
            % app.AcknowledgmentText.HorizontalAlignment = 'center';
            % app.AcknowledgmentText.FontSize = 20;
            % app.AcknowledgmentText.FontWeight = 'bold';
            % app.AcknowledgmentText.Position = [480 146 600 38];
            % app.AcknowledgmentText.Text = 'Developed by RAJAN KUMAR and Dr. Sudhir Varma';

            % Create StartButton
            app.StartButton = uibutton(app.StartWindow, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.FontSize = 15;
            app.StartButton.Position = [400 700 300 30];
            app.StartButton.Text = 'Start Back Calculation- Single Run ';
            app.StartButton.BackgroundColor = [0.4 0.4 0.2];

            app.StartButton = uibutton(app.StartWindow, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonBatchPushed, true);
            app.StartButton.FontSize = 15;
            app.StartButton.Position = [840 700 300 30];
            app.StartButton.Text = 'Start Back Calculation- Batch Run ';
            app.StartButton.BackgroundColor = [0.4 0.4 0.2];

            app.UIFigure2 = uifigure('Name', 'RajanPaveBatch', 'Position', appPosition);
            app.UIFigure2.Visible = 'off';

            app.loadButton1 = uibutton(app.UIFigure2, 'push');
            app.loadButton1.ButtonPushedFcn = createCallbackFcn(app, @inputtextPushed, true);
            app.loadButton1.Position = [230, 710, 300, 25];
            % app.loadButton1.BackgroundColor = [0.3 0.5 0.9];
            app.loadButton1.FontSize = 16;
            app.loadButton1.Text = 'Load Text File:';

            app.BackCalculate1 = uibutton(app.UIFigure2, 'push');
            app.BackCalculate1.ButtonPushedFcn = createCallbackFcn(app, @BackCalculateBatchPushed, true);
            app.BackCalculate1.Position = [630, 710,300, 25];
            app.BackCalculate1.FontSize = 16;
            app.BackCalculate1.Text = 'Start BackCalculation in Batch';

            app.acnButton = uibutton(app.UIFigure2, 'push');
            app.acnButton.ButtonPushedFcn = createCallbackFcn(app, @textFileFormat, true);
            app.acnButton.Position = [935 170 100 38];
            app.acnButton.FontSize = 16;
            app.acnButton.FontWeight = 'bold';
            app.acnButton.Text = 'Text File Format ';
            app.acnButton.BackgroundColor = [0.3 0.5 0.9];

            app.acnButton = uibutton(app.StartWindow, 'push');
            app.acnButton.ButtonPushedFcn = createCallbackFcn(app, @acnButtonPushed, true);
            app.acnButton.Position = [935 170 100 38];
            app.acnButton.FontSize = 16;
            app.acnButton.FontWeight = 'bold';
            app.acnButton.Text = 'ABOUT';
            app.acnButton.BackgroundColor = [0.3 0.5 0.9];

            app.acnButton = uibutton(app.StartWindow, 'push');
            app.acnButton.ButtonPushedFcn = createCallbackFcn(app, @acnButtonPushed, true);
            app.acnButton.Position = [1040 170 100 38];
            app.acnButton.FontSize = 16;
            app.acnButton.FontWeight = 'bold';
            app.acnButton.Text = 'CONTACT';
            app.acnButton.BackgroundColor = [0.3 0.5 0.9];

            
            app.HelpButton = uibutton(app.UIFigure, 'push');
            app.HelpButton.ButtonPushedFcn = createCallbackFcn(app, @helpButtonPushed, true);
            app.HelpButton.Position = [420, 838, 100, 25];
            app.HelpButton.FontSize = 16;
            app.HelpButton.Text = 'HELP ?';
            app.HelpButton.BackgroundColor = [0.3 0.5 0.9];

            app.inputLabel = uilabel(app.UIFigure);
            app.inputLabel.Text = 'INPUTS TO SOFTWARE: ';
            app.inputLabel.FontSize = 16;
            app.inputLabel.Position = [30, 840, 300, 22];

            
            app.loadButton = uibutton(app.UIFigure, 'push');
            app.loadButton.ButtonPushedFcn = createCallbackFcn(app, @loadButtonPushed, true);
            app.loadButton.Position = [230, 838, 185, 25];
            app.loadButton.BackgroundColor = [0.3 0.5 0.9];
            app.loadButton.FontSize = 16;
            app.loadButton.Text = 'LOAD RESULT FILE';

            app.deflPlotLabel = uilabel(app.UIFigure);
            app.deflPlotLabel.Text = 'DEFLECTION VS RADIAL DISTANCE : ';
            app.deflPlotLabel.FontSize = 16;
            app.deflPlotLabel.Position = [1000, 840, 300, 22];

            app.paretoLabel = uilabel(app.UIFigure);
            app.paretoLabel.Text = 'PARETO FRONT OF SOLUTIONS : ';
            app.paretoLabel.FontSize = 16;
            app.paretoLabel.Position = [1000, 475, 300, 22];


            app.layerCntLabel = uilabel(app.UIFigure);
            app.layerCntLabel.Text = 'No. of Layers :';
            app.layerCntLabel.FontSize = 14; % Set font size to 14
            app.layerCntLabel.Position = [30, 815, 300, 18];
            app.layersCnt = uieditfield(app.UIFigure, 'text');
            app.layersCnt.Position = [210, 815, 400, 18];

            % RCLabel
            app.RCLabel = uilabel(app.UIFigure);
            app.RCLabel.Text = 'Radial Distances :';
            app.RCLabel.FontSize = 14; % Set font size to 14
            app.RCLabel.Position = [30, 790, 300, 18];
            app.RCEditField = uieditfield(app.UIFigure, 'text');
            app.RCEditField.Position = [210, 790, 400, 18];

            app.unitDropdownRc = uidropdown(app.UIFigure);
            app.unitDropdownRc.Items = {'inches','mils' ,'mm', 'cm'};
            app.unitDropdownRc.Position = [150 790 55 18];
            app.unitDropdownRc.Value = 'inches';
            app.unitDropdownRc.FontSize = 8;


            % DEFLLabel
            app.DEFLLabel = uilabel(app.UIFigure);
            app.DEFLLabel.Text = 'Deflection Values :';
            app.DEFLLabel.FontSize = 14; % Set font size to 14
            app.DEFLLabel.Position = [30, 765, 300, 18];
            app.DEFLEditField = uieditfield(app.UIFigure, 'text');
            app.DEFLEditField.Position = [210, 765, 400, 18];

            app.unitDropdownDefl = uidropdown(app.UIFigure);
            app.unitDropdownDefl.Items = {'inches','mils' ,'mm', 'cm'};
            app.unitDropdownDefl.Position = [150 765 55 18];
            app.unitDropdownDefl.Value = 'inches';
            app.unitDropdownDefl.FontSize = 8;



            % LBLabel
            app.LBLabel = uilabel(app.UIFigure);
            app.LBLabel.Text = 'Lower Limits :';
            app.LBLabel.FontSize = 14; % Set font size to 14
            app.LBLabel.Position = [30, 740, 300, 18];
            app.LBEditField = uieditfield(app.UIFigure, 'text');
            app.LBEditField.Position = [210, 740, 400, 18];

            app.unitDropdownLb = uidropdown(app.UIFigure);
            app.unitDropdownLb.Items = {'psi', 'mpa', 'pa'};
            app.unitDropdownLb.Position = [150 740 55 18];
            app.unitDropdownLb.Value = 'psi';
            app.unitDropdownLb.FontSize = 8;

            % UBLabel
            app.UBLabel = uilabel(app.UIFigure);
            app.UBLabel.Text = 'Upper Limits :';
            app.UBLabel.FontSize = 14; % Set font size to 14
            app.UBLabel.Position = [30, 715, 300, 18];
            app.UBEditField = uieditfield(app.UIFigure, 'text');
            app.UBEditField.Position = [210, 715, 400, 18];

            app.unitDropdownUb = uidropdown(app.UIFigure);
            app.unitDropdownUb.Items = {'psi', 'mpa', 'pa'};
            app.unitDropdownUb.Position = [150 715 55 18];
            app.unitDropdownUb.Value = 'psi';
            app.unitDropdownUb.FontSize = 8;

            % THELabel
            app.THELabel = uilabel(app.UIFigure);
            app.THELabel.Text = 'Layer Thickness :';
            app.THELabel.FontSize = 14; % Set font size to 14
            app.THELabel.Position = [30, 690, 300, 18];
            app.THEditField = uieditfield(app.UIFigure, 'text');
            app.THEditField.Position = [210, 690, 400, 18];

            app.unitDropdownTH = uidropdown(app.UIFigure);
            app.unitDropdownTH.Items = {'inches','mils' ,'mm', 'cm'};
            app.unitDropdownTH.Position = [150 690 55 18];
            app.unitDropdownTH.Value = 'inches';
            app.unitDropdownTH.FontSize = 8;

             % CRLabel
            app.CRLabel = uilabel(app.UIFigure);
            app.CRLabel.Text = 'Contact Radius :';
            app.CRLabel.FontSize = 14; % Set font size to 14
            app.CRLabel.Position = [30, 665, 300, 18];
            app.CREditField = uieditfield(app.UIFigure, 'text');
            app.CREditField.Position = [210, 665, 400, 18];


            app.unitDropdownCR = uidropdown(app.UIFigure);
            app.unitDropdownCR.Items = {'inches','mils' ,'mm', 'cm'};
            app.unitDropdownCR.Position = [150 665 55 18];
            app.unitDropdownCR.Value = 'inches';
            app.unitDropdownCR.FontSize = 8;

            % StressLabel
            app.StressLabel = uilabel(app.UIFigure);
            app.StressLabel.Text = 'Contact Pressure :';
            app.StressLabel.FontSize = 14; % Set font size to 14
            app.StressLabel.Position = [30, 640, 300, 18];
            app.StressEditField = uieditfield(app.UIFigure, 'text');
            app.StressEditField.Position = [210, 640, 400, 18];

            app.unitDropdownStress = uidropdown(app.UIFigure);
            app.unitDropdownStress.Items = {'psi', 'mpa', 'pa'};
            app.unitDropdownStress.Position = [150 640 55 18];
            app.unitDropdownStress.Value = 'psi';
            app.unitDropdownStress.FontSize = 8;


            % PRELabel
            app.PRELabel = uilabel(app.UIFigure);
            app.PRELabel.Text = 'Poissons Ratios :';
            app.PRELabel.FontSize = 14; % Set font size to 14
            app.PRELabel.Position = [30, 615, 300, 18];
            app.PREditField = uieditfield(app.UIFigure, 'text');
            app.PREditField.Position = [210, 615, 400, 18];

            % ZCLabel
            app.ZCLabel = uilabel(app.UIFigure);
            app.ZCLabel.Text = 'ZC (0 for surface defl.) :';
            app.ZCLabel.FontSize = 14; % Set font size to 14
            app.ZCLabel.Position = [30, 590, 300, 18];
            app.ZCEditField = uieditfield(app.UIFigure, 'text');
            app.ZCEditField.Position = [210, 590, 400, 18];

           


            % PopLabel
            app.PopLabel = uilabel(app.UIFigure);
            app.PopLabel.Text = 'Number of Populations :';
            app.PopLabel.FontSize = 14; % Set font size to 14
            app.PopLabel.Position = [30, 565, 300, 18];
            app.PopEditField = uieditfield(app.UIFigure, 'text');
            app.PopEditField.Position = [210, 565, 400, 18];

            % GensLabel
            app.GensLabel = uilabel(app.UIFigure);
            app.GensLabel.Text = 'Number of Generations :';
            app.GensLabel.FontSize = 14; % Set font size to 14
            app.GensLabel.Position = [30, 540, 300, 18];
            app.GensEditField = uieditfield(app.UIFigure, 'text');
            app.GensEditField.Position = [210, 540, 400, 18];

            % RNGSeederLabel
            app.RNGSeederLabel = uilabel(app.UIFigure);
            app.RNGSeederLabel.Text = 'RNG Seed :';
            app.RNGSeederLabel.FontSize = 14; % Set font size to 14
            app.RNGSeederLabel.Position = [30, 515, 300, 18];
            app.RNGSeederEditField = uieditfield(app.UIFigure, 'text');
            app.RNGSeederEditField.Position = [210, 515, 400, 18];

            % NameLabel
            app.NameLabel = uilabel(app.UIFigure);
            app.NameLabel.Text = 'File Name :';
            app.NameLabel.FontSize = 14; % Set font size to 14
            app.NameLabel.Position = [30, 490, 300, 18];
            app.NameEditField = uieditfield(app.UIFigure, 'text');
            app.NameEditField.Position = [210, 490, 400, 18];

            % ThresholdLabel
            app.ThresholdLabel = uilabel(app.UIFigure);
            app.ThresholdLabel.Text = 'Error Threshold :';
            app.ThresholdLabel.FontSize = 14; % Set font size to 14
            app.ThresholdLabel.Position = [30, 465, 300, 18];
            app.ThresholdEditField = uieditfield(app.UIFigure, 'text');
            app.ThresholdEditField.Position = [210, 465, 400, 18];

            app.resultLabel = uilabel(app.UIFigure);
            app.resultLabel.Text = 'RESULTS : ';
            app.resultLabel.FontSize = 16;
            app.resultLabel.Position = [30, 420, 300, 22];

            app.unitDropdownResult = uidropdown(app.UIFigure);
            app.unitDropdownResult.Items = {'psi', 'mpa', 'pa'};
            app.unitDropdownResult.Position = [150 420 75 18];
            app.unitDropdownResult.Value = 'psi';
            app.unitDropdownResult.FontSize = 18;

            app.changeUnit = uibutton(app.UIFigure, 'push');
            app.changeUnit.ButtonPushedFcn = createCallbackFcn(app, @changeUnitPushed, true);
            app.changeUnit.Position = [240 419 80 22];
            app.changeUnit.Text = 'Change Unit';
            app.changeUnit.BackgroundColor = [0.4 0.4 0.2];

            app.SolIdLabel = uilabel(app.UIFigure);
            app.SolIdLabel.Text = 'Enter Solution ID : ';
            app.SolIdLabel.FontSize = 14;
            app.SolIdLabel.Position = [30 75 400 22];
            app.SolIdEditField = uieditfield(app.UIFigure,'text');
            app.SolIdEditField.Position = [150 75 40 22];

            app.SOlIdRangeLabel = uilabel(app.UIFigure);
            app.SOlIdRangeLabel.Text = 'Enter Solution ID Range : ';
            app.SOlIdRangeLabel.FontSize = 14;
            app.SOlIdRangeLabel.Position = [360 75 400 22];
            app.SolIdLB = uieditfield(app.UIFigure,'text');
            app.SolIdLB.Position = [525 75 40 22];

            app.toLabel = uilabel(app.UIFigure);
            app.toLabel.Text = 'to';
            app.toLabel.FontSize = 14;
            app.toLabel.Position = [568 75 400 22];

            app.SolIdUB = uieditfield(app.UIFigure,'text');
            app.SolIdUB.Position = [582 75 40 22];

            app.checkDeflProfies = uibutton(app.UIFigure, 'push');
            app.checkDeflProfies.ButtonPushedFcn = createCallbackFcn(app, @checkDeflProfilesPushed, true);
            app.checkDeflProfies.Position = [630,65, 150, 40];
            app.checkDeflProfies.Text = 'Check Deflection Profiles';
            app.checkDeflProfies.BackgroundColor = [0.4 0.4 0.2];

           
            app.checkDeflProfile = uibutton(app.UIFigure, 'push');
            app.checkDeflProfile.ButtonPushedFcn = createCallbackFcn(app, @checkDeflProfilePushed, true);
            app.checkDeflProfile.Position = [195,65, 150, 40];
            app.checkDeflProfile.Text = 'Check Deflection Profile';
            app.checkDeflProfile.BackgroundColor = [0.4 0.4 0.2];

            % Default Values
            app.layersCnt.Value = '3';
            disp('hi');
            disp(app.layersCnt.Value);
            app.RCEditField.Value ='0 7.87 11.81 17.72 23.62 35.43 47.24 59.06';
            app.DEFLEditField.Value ='0.01968 0.0168 0.01503 0.01275 0.01092 0.008304 0.006576 0.005359';
            app.LBEditField.Value ='290075.5 7251.89 1450.38';
            app.UBEditField.Value ='580151.0 72518.9 43511.4';
            app.THEditField.Value ='6.299216 17.716545';
            app.PREditField.Value ='0.35 0.35 0.35';
            app.ZCEditField.Value ='0';
            app.CREditField.Value ='5.936460244';
            app.StressEditField.Value ='81.22';
            app.PopEditField.Value ='200';
            app.GensEditField.Value ='5';
            app.RNGSeederEditField.Value ='07';
            app.NameEditField.Value ='file_1';
            app.ThresholdEditField.Value ='1';

            app.ResultPoints.Position = [630, 800,150, 40];
            app.ResultPoints.Text = 'Result Data Set from BackCalculation';


            % Create SubmitButton
            app.PlotButton = uibutton(app.UIFigure, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [630, 760, 150, 40];
            app.PlotButton.Text = 'Plot Measured Deflections';
            app.PlotButton.BackgroundColor = [0, 0, 0.5];

            % Create SubmitButton
            app.BackCalculate = uibutton(app.UIFigure, 'push');
            app.BackCalculate.ButtonPushedFcn = createCallbackFcn(app, @BackCalculatePushed, true);
            app.BackCalculate.Position = [630, 710,150, 40];
            app.BackCalculate.Text = 'Start BackCalculation';
            
            app.BackCalculate.BackgroundColor = [0, 0.5, 0]; % Green color
            app.BackCalculate.FontWeight = 'bold';
            app.BackCalculate.FontSize = 13;

            % Create SubmitButton
            app.checkForFaultySensor = uibutton(app.UIFigure, 'push');
            app.checkForFaultySensor.ButtonPushedFcn = createCallbackFcn(app, @checkForFaultySensorPushed, true);
            app.checkForFaultySensor.Position = [630, 600,150, 40];
            app.checkForFaultySensor.Text = 'Check Faulty Sensor';
            app.checkForFaultySensor.BackgroundColor = [0, 0, 0.5];

            % Create SubmitButton
            app.RemoveFaultedSensor = uibutton(app.UIFigure, 'push');
            app.RemoveFaultedSensor.ButtonPushedFcn = createCallbackFcn(app, @RemoveFaultedSensorPushed, true);
            app.RemoveFaultedSensor.Position = [630, 463 ,150, 40];
            app.RemoveFaultedSensor.Text = 'Remove Faulted Sensor';
            app.RemoveFaultedSensor.BackgroundColor = [0, 0, 0.5];

            app.executionStatusLabel = uilabel(app.UIFigure);
            app.executionStatusLabel.Text = "EXECUTION STATE : ";
            app.executionStatusLabel.FontSize = 14;
            app.executionStatusLabel.Position = [605 840 150 22];

            app.UITextArea2 = uitextarea(app.UIFigure);
            app.UITextArea2.Position = [745, 840,70, 22];
            app.UITextArea2.Value = 'IDLE';  % Initialize the text area content
            app.UITextArea2.BackgroundColor = [0.3 0.5 0.9];

            % Create UIAxes to display image
            app.UIAxes1 = uiaxes(app.UIFigure);
            app.UIAxes1.Position = [800, 495, 700, 340];

             % Create UIAxes to display image
            app.UIAxes2 = uiaxes(app.UIFigure);
            app.UIAxes2.Position = [800, 50, 700, 420];


            % Create a UITable to display the data
            app.ResTable = uitable(app.UIFigure);
            app.ResTable.Position = [30 115 750 300];

            app.UITextArea = uitextarea(app.UIFigure);
            app.UITextArea.Position = [630, 513,150, 80];
            app.UITextArea.FontSize = 15;
            app.UITextArea.Placeholder = 'Faulted Sensor will be displayed here !! ';
            app.UITextArea.BackgroundColor = [0.2 0.2 0.2];
            app.UITextArea.Value = '';  % Initialize the text area content

            
        end
    end


    % App creation and deletion  
    methods (Access = public) 
        % Construct app
        function app = RajanPave
            % Create and configure components
            
            createComponents(app)
            % Show the figure after all components are created
            app.UIFigure.Visible = 'off';
            app.UIFigure2.Visible = 'off';
        end
        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure);
            delete(app.UIFigure2);
        end
    end

end

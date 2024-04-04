%  Name: Rajan Kumar
%  Roll No: 2001CE46
%  Single Backcalculate

function res = main_single(stat,faultedSensor,numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err)
    clc;
    close all;
    disp(5);
    if stat == -1 && faultedSensor == -1
        res = EstimateModulus(numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err);
       
    end

    if stat ~= -1 && faultedSensor == -1
        currentStatus = EstimateModulus(numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err);
        res = identifyFaultySensor(currentStatus,numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err);
    end

    if stat == -1 && faultedSensor ~= -1
        removeFaultySensor(faultedSensor,numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err);
    end
   
end


function faultySensor = identifyFaultySensor(status,numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err)
faultySensor = -2;
if status == 0
    myString = 'No Error Happy :)';            
    % Define the directory path and the file name
    directoryPath = '../MULTI_OBJ_GA-OUTPUTS/';
    fileName = ['output-',nameDifferentiator,'.txt'];
    
    % Combine directory path and file name
    fullFileName = fullfile(directoryPath, fileName);
    
    % Save the string to a text file
    writecell({myString}, fullFileName);
   
 
elseif status == 1
    detected = 0;
    for i = 1:2:numel(RC)
        index1 = i;
        index2 = i + 1;
        if(index2 > numel(RC))
            index2 = index2 - 2;
        end
        RC_Modf = RC;
        RC_Modf(index1) = RC(index2);
        RC_Modf(index2) = RC(index1);
        DEFL_Modf = DEFL;
        DEFL_Modf(index1) = DEFL(index2);
        DEFL_Modf(index2) = DEFL(index1);
        nameDiff = [nameDifferentiator 'swapping sensor' num2str(i)];

        status = EstimateModulus(numOfLayers,TH,RC_Modf,DEFL_Modf,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDiff,threshold_err);

        if status ~= 1
            detected = 1;
            myString = ['Error in set - 1 ','at sensor no: ',num2str(i)];      
             
            % Define the directory path and the file name
            directoryPath = '../MULTI_OBJ_GA-OUTPUTS/';
            fileName = ['output-',nameDifferentiator,'.txt'];
            
            % Combine directory path and file name
            fullFileName = fullfile(directoryPath, fileName);
            
            % Save the string to a text file
            writecell({myString}, fullFileName);
            faultySensor = i;                       
      
        end

    end
    if detected == 0
        myString = ["Error in set - 1" "- couldn't find the exact sensor sorry :("];      
         
        % Define the directory path and the file name
        directoryPath = '../MULTI_OBJ_GA-OUTPUTS/';
        fileName = ['output-',nameDifferentiator,'.txt'];
        
        % Combine directory path and file name
        fullFileName = fullfile(directoryPath, fileName);
        
        % Save the string to a text file
        writecell({myString}, fullFileName);
    end

else 
    detected = 0;
    for i = 2:2:numel(RC)
        index1 = i;
        index2 = i - 1;
        RC_Modf = RC;
        RC_Modf(index1) = RC(index2);
        RC_Modf(index2) = RC(index1);
        DEFL_Modf = DEFL;
        DEFL_Modf(index1) = DEFL(index2);
        DEFL_Modf(index2) = DEFL(index1);

        nameDiff = [nameDifferentiator, 'swapping sensor', num2str(i)];
        status = EstimateModulus(numOfLayers,TH,RC_Modf,DEFL_Modf,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDiff);
        if status ~= 2
            detected = 1;
            myString = ['Error in set - 2 ','at sensor no: ',num2str(i)];      
             
            % Define the directory path and the file name
            directoryPath = '../MULTI_OBJ_GA-OUTPUTS/';
            fileName = ['output-',nameDifferentiator,'.txt'];
            
            % Combine directory path and file name
            fullFileName = fullfile(directoryPath, fileName);                    
            % Save the string to a text file
            writecell({myString}, fullFileName);
            faultySensor = i;               
        end
    end
    if detected == 0
        myString = ["Error in set - 2" "-couldn't find the exact sensor sorry :("];      
         
        % Define the directory path and the file name
        directoryPath = '../MULTI_OBJ_GA-OUTPUTS/';
        fileName = ['output-',nameDifferentiator,'.txt'];
        
        % Combine directory path and file name
        fullFileName = fullfile(directoryPath, fileName);
        
        % Save the string to a text file
        writecell({myString}, fullFileName);
    end
end
end


function removeFaultySensor(faultySensor,numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err)
    if faultySensor ~= -1
            if rem(faultySensor , 2) == 0
                duplicateSensor = faultySensor - 1;
            else
                duplicateSensor = faultySensor + 1;
            end

            DEFL_Mod = DEFL;
            RC_Mod = RC;
            DEFL_Mod(faultySensor) = DEFL(duplicateSensor);
            RC_Mod(faultySensor) = RC(duplicateSensor);
            nameD = [nameDifferentiator 'removedSensor-' num2str(faultySensor)];
            status = EstimateModulus(numOfLayers,TH,RC_Mod,DEFL_Mod,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameD,threshold_err);
            % getIndivisualError(actualval,nameD);
    end
end


function status = EstimateModulus(numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err)
    status = multiScript(numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err);
end




function [numOfLayers,TH_Batch, RC_Batch, DEFL_Batch, LB_Batch, UB_Batch, PR_Batch, ...
    ZC_Batch, CR_Batch, STRESS_Batch, POP_Batch, GENS_Batch, RNGSEEDER_Batch, ...
    nameDifferentiatorBatch, threshold_err_Batch] = readDataFromFile(fileName)
   

    fileID = fopen(fileName, 'r');
    fileContents = fread(fileID, '*char')';
    fclose(fileID);
    eval(fileContents);
    
    % Return the variables
    numOfLayers = numOfLayers;
    TH_Batch = TH_Batch;
    RC_Batch = RC_Batch;
    DEFL_Batch = DEFL_Batch;
    LB_Batch = LB_Batch;
    UB_Batch = UB_Batch;
    PR_Batch = PR_Batch;
    ZC_Batch = ZC_Batch;
    CR_Batch = CR_Batch;
    STRESS_Batch = STRESS_Batch;
    POP_Batch = POP_Batch;
    GENS_Batch = GENS_Batch;
    RNGSEEDER_Batch = RNGSEEDER_Batch;
    nameDifferentiatorBatch = nameDifferentiatorBatch;
    threshold_err_Batch = threshold_err_Batch;
end

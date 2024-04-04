
%  Name: Rajan Kumar
%  Roll No: 2001CE46
%  Back Calculate in Batch.

function main_batch(numOfLayers,TH_Batch,RC_Batch,DEFL_Batch,LB_Batch, UB_Batch, PR_Batch, ZC_Batch, CR_Batch, STRESS_Batch, POP_Batch, GENS_Batch, RNGSEEDER_Batch,nameDifferentiator_Batch,threshold_err_Batch)
    for i = 1:numel(DEFL_Batch)
        TH = TH_Batch{i};
        RC = RC_Batch{i};
        DEFL = DEFL_Batch{i};
        LB = LB_Batch{i};
        UB = UB_Batch{i};
        PR = PR_Batch{i};
        ZC = ZC_Batch{i};
        CR = CR_Batch{i};
        STRESS = STRESS_Batch{i};
        POP = POP_Batch{i};
        GENS = GENS_Batch{i};
        RNGSEEDER = RNGSEEDER_Batch{i};    
        nameDifferentiator = nameDifferentiator_Batch{i};
        threshold_err = threshold_err_Batch{i};
        main_single(-1,-1,numOfLayers,TH,RC,DEFL,LB,UB,PR,ZC,CR,STRESS,POP,GENS,RNGSEEDER,nameDifferentiator,threshold_err);
    end    
end




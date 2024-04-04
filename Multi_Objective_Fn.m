function f = Multi_Objective_Fn(cinit,pdefl,TH,RC,PR,ZC,CR,STRESS)
    % ### cinit --> elastic modulus of layers starting from top.    
    NL = length(TH)+1 ;           % number of layers
    NZ = length(ZC);              % number of z-cooridnates for analysis
    NR = length(RC);              % NR=number of radial coordinates to be analyzed under a single wheel, maximum 25        
    Etcur = cinit(1);
    Eunbound = cinit(2:end);
    
    % ### Forward Calculation: 
    out1 = f_calc_unit_response_chev(NL, NZ, TH, PR, ZC, CR, STRESS, NR, RC, length(Etcur), Eunbound, Etcur);
    
    % splitIndex = numel(RC)/2;  % Spliting the set of geophones into two halfs
    
    out1_first = out1(1:2:numel(RC));
    out1_second = out1(2:2:numel(RC));
    pdefl_first = pdefl(1:2:numel(RC));
    pdefl_second = pdefl(2:2:numel(RC));
    
    % ### Calculation of root mean square error which is output of function: 
    rmse1 = ((sum(((out1_first-pdefl_first)./pdefl_first).^2))/length(pdefl_first))^0.5*100;
    rmse2 = ((sum(((out1_second-pdefl_second)./pdefl_second).^2))/length(pdefl_second))^0.5*100;
    f(1) = rmse1;
    f(2) = rmse2;
end




function [SNR1,eta_Sq] = Computation_rate(param,i_AIRS,Dist_matrix)

%% WIT Case
beta0 = param.beta0;
sigma = param.sigma;
delta = param.delta;
alpha = param.alpha;
N_pass = param.N_pass; 
N_act = param.N_act;
P_F = param.P_F*N_act; 
P_T = param.P_T;
num_IRS = param.num_IRS;
num_ante = param.num_ante;

eta_Sq = 1;

PG_d1 = beta0*Dist_matrix.^(-alpha);

if i_AIRS
    % Multi-AIRS/PIRS
    eta_Sq = P_F/(prod(PG_d1(1:i_AIRS))* N_pass^(2*(i_AIRS-1))*N_act*num_ante*P_T + delta*sigma*N_act);
    
    num_part = prod(PG_d1) * N_pass^(2*(num_IRS-1))*N_act^2* num_ante * P_T;
    
    dem_part = (prod(PG_d1(i_AIRS+1:end))* N_pass^(2*(num_IRS-i_AIRS))*N_act*delta + 1/eta_Sq) * sigma;
    
else
   % All-PIRS
   num_part = prod(PG_d1) * N_pass^(2*(num_IRS))*num_ante*(P_T+P_F); 
   dem_part =  sigma;
end    
    
SNR1 = num_part/dem_part; 


end





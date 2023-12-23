
function [Q1,eta_Sq] = Computation_power(param,i_AIRS,dist_matrix)

%% WPT Case
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


PG_d = beta0*dist_matrix.^(-alpha);

if i_AIRS
    % Multi-AIRS/PIRS
    eta_Sq = P_F/(prod(PG_d(1:i_AIRS))* N_pass^(2*(i_AIRS-1))*N_act*num_ante*P_T + delta*sigma*N_act);
    num_part1 = eta_Sq* prod(PG_d) * N_pass^(2*(num_IRS-1))*N_act^2*num_ante*P_T;
    num_part2 =  eta_Sq* prod(PG_d(i_AIRS+1:num_IRS+1))* N_pass^(2*(num_IRS-i_AIRS))*N_act*delta * sigma;
    
else
   % All-PIRS 
   num_part1 = prod(PG_d) * N_pass^(2*(num_IRS))*num_ante*(P_T+P_F); 
   num_part2 =  0;
end    
    
Q1 = num_part1 + num_part2; 


end





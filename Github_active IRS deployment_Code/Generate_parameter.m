
           
num_IRS = 7;
P_F = db2pow(-10)/10^3; 
P_T = db2pow(30)/10^3;
N_pass = 1000; N_act = 150; 

%%
beta0 = db2pow(-43); 
alpha = 2;
sigma = db2pow(-60)/10^3;
delta = 1;
sigma_F = sigma*delta; 
num_ante = 10;
 

param.beta0 = beta0;
param.sigma = sigma;
param.sigma_F = sigma_F;
param.alpha = alpha;
param.delta = delta; 
param.P_T = P_T; 
param.P_F = P_F; 
param.N_act = N_act; 
param.N_pass = N_pass; 
param.num_IRS = num_IRS;
param.num_ante = num_ante;


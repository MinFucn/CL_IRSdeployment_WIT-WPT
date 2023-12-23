clear;clc;

%%

Generate_parameter
num_IRS = param.num_IRS;


d_fix = 10; Path_G_fix = beta0*d_fix^(-alpha); Dist_matrix = [4;d_fix*ones(param.num_IRS-1,1);4];

N_pass_set = [3e2:1e2:1.1e3]; x_set =  N_pass_set;
len_x = length(N_pass_set); 



for ik = 1:4
    eval(['SNR_max',num2str(ik),'=','zeros(len_x,1)',';']);
    eval(['Q_max',num2str(ik),'=','zeros(len_x,1)',';']);
end


for ik = 1
    eval(['SNR_matrix',num2str(ik),'=','zeros(len_x,num_IRS)',';']);
    eval(['Q_matrix',num2str(ik),'=','zeros(len_x,num_IRS)',';']);
    eval(['Q_index',num2str(ik),'=','zeros(len_x,1)',';']);
    eval(['SNR_index',num2str(ik),'=','zeros(len_x,1)',';']);
end




%% WIT/WPT
iy = 1;
for ix = 1:len_x
    
    N_pass = N_pass_set(ix);
    param.N_pass = N_pass_set(ix);
       
   %% optimal   
    for i_AIRS = 1: param.num_IRS
        [SNR_matrix1(ix,i_AIRS)] = Computation_rate(param,i_AIRS,Dist_matrix);      
        [Q_matrix1(ix,i_AIRS)] = Computation_power(param,i_AIRS,Dist_matrix);
    end
    
    temp = find(SNR_matrix1(ix,:) == max(SNR_matrix1(ix,:)));
    SNR_max1(ix,iy) = SNR_matrix1(ix,temp(1));  SNR_index1(ix,iy) = temp(1);     
    
    temp = find(Q_matrix1(ix,:) == max(Q_matrix1(ix,:)));  
    Q_max1(ix,iy) = Q_matrix1(ix,temp(1)); Q_index1(ix,iy) = temp(1);
      
    %%  All-PIRS
    SNR_max2(ix,iy) = Computation_rate(param,0,Dist_matrix);
    Q_max2(ix,iy) = Computation_power(param,0,Dist_matrix);
    
    %% l = (J+1)/2
     [SNR_max3(ix,iy)] = Computation_rate(param,(param.num_IRS+1)/2,Dist_matrix);  
     [Q_max3(ix,iy)] = Computation_power(param,(param.num_IRS+1)/2,Dist_matrix);
     
     %% l = J
     [SNR_max4(ix,iy)] = Computation_rate(param,param.num_IRS,Dist_matrix);  
     [Q_max4(ix,iy)] = Computation_power(param,param.num_IRS,Dist_matrix); 
      
end
     


%% plot figure 2--4
flog1 =0;
if flog1   
    line_marker = {'b-o','r--','b-V','r-.';'g-o','r-.','g-V','k-.'};
    
    marker = {'o','diamond','*','^','pentagram'};
    lineColors = lines(7); lineColors = [lineColors;[96, 96, 96]/255;]; %% gray
    
    %% WIT performance versus Np
    figure(1)
    index1 = 2:len_x;
    x_set1 = x_set(index1);
    plot(x_set1, pow2db(SNR_max1(index1)),'-pentagram','LineWidth',2,'MarkerSize',8); hold on
    plot(x_set1, pow2db(SNR_max3(index1)),'-.s','LineWidth',2,'MarkerSize',8); hold on 
    plot(x_set1, pow2db(SNR_max4(index1)),'--^','LineWidth',2,'MarkerSize',8); hold on    
    plot(x_set1, pow2db(SNR_max2(index1)),'-diamond','LineWidth',2,'MarkerSize',8); hold on    
    grid on;
    set(gca,'GridLineStyle','--','GridColor','k', 'GridAlpha',0.2);  
    h11 = legend('Multi-AIRS/PIRS with optimal $l$','Multi-AIRS/PIRS with $l=\frac{J+1}{2}$','Multi-AIRS/PIRS with $l=J$','All-PIRS Benchmark','interpreter','latex');
    set(h11,'FontSize',15);
    xlabel('Number of PIRS elements, $N_p$','interpreter','latex','FontSize',15);
    ylabel('Received SNR in WIT, $\gamma$ (dB)','interpreter','latex','FontSize',15);
    xlim([x_set1(1) x_set1(end)])
    ylim([-30 45])
    
    saveas(gcf,'WIT-Np.fig'); print("WIT-Np",'-depsc2');
    
   %% WPT performance versus Np
    figure(2)
    plot(x_set1, pow2db(Q_max1(index1)*10^3),'-pentagram','LineWidth',2,'MarkerSize',8); hold on
    plot(x_set1, pow2db(Q_max3(index1)*10^3),'-.s','LineWidth',2,'MarkerSize',8); hold on 
    plot(x_set1, pow2db(Q_max4(index1)*10^3),'--^','LineWidth',2,'MarkerSize',8); hold on   
    plot(x_set1, pow2db(Q_max2(index1)*10^3),'-diamond','LineWidth',2,'MarkerSize',8); hold on    
    grid on;
    set(gca,'GridLineStyle','--','GridColor','k', 'GridAlpha',0.2);  
    h11 = legend('Multi-AIRS/PIRS with optimal $l$','Multi-AIRS/PIRS with $l=\frac{J+1}{2}$','Multi-AIRS/PIRS with $l=J$','All-PIRS Benchmark','interpreter','latex');
    set(h11,'FontSize',15);
    xlabel('Number of PIRS elements, $N_p$','interpreter','latex','FontSize',15);
    ylabel('Received RF Power in WPT, $Q$ (dBm)','interpreter','latex','FontSize',15)
    
    saveas(gcf,'WPT-Np.fig'); print("WPT-Np",'-depsc2');
   
   %% plot index
    
    figure(3)
    index1 = 1:len_x;
    x_set1 = x_set(index1);
    plot(x_set1, SNR_index1(index1),'-diamond','LineWidth',2,'MarkerSize',8); hold on
    plot(x_set1, Q_index1(index1),'-pentagram','LineWidth',2,'MarkerSize',8); hold on  
    xlabel('Number of PIRS elements, $N_p$','interpreter','latex','FontSize',15);
    ylabel('Optimal index of AIRS, $l$','interpreter','latex','FontSize',15);   
    grid on;
    set(gca,'GridLineStyle','--','GridColor','k', 'GridAlpha',0.2);  
    h11 = legend('Multi-AIRS/PIRS-aided WIT','Multi-AIRS/PIRS-aided WPT','interpreter','latex');
    set(h11,'FontSize',15);   
    yticks([1:param.num_IRS])
    
    saveas(gcf,'index-Np.fig'); print("index-Np",'-depsc2');
end

function w=algorithm_no_distribution(S,n,N,MCMC_m)
%没有分布估计
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入：时间序列S，一致超图阶数n，节点数N，MCMC序列长度MCMC_m
%输出：重构网络w

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=length(S);%时间步长
[P,P_dl]=inniti_P(S,n,N);%初始化概率矩阵
H_allconfig=cell(1,T);%存储上次迭代每个时间段构型
[H_config,H_config_dl,d]=MCMC(S,P,N,MCMC_m,H_allconfig,P_dl,n);
wall_i=sample_nx_2(H_config,H_config_dl,d,P);
w=P(wall_i~=0,1);
clear
clc

%参数设置
P_a=0.1;%概率矩阵更新参数(学习速率)
N=20;%节点数 
M=50;%超边数 

n=2;%一致超图阶数
k=3;%每个时间段边数
T=200;%时间段长度
MCMC_m=1000;%MCMC序列长度
s=20;%时间间隔

%生成网络
id=3;   %网络编号 ER:1 WS:2 BA:3
[S,w_true,N]=create_w(N,M,T,k,n,id,s);

%BNRDEM结果
w=algorithm(S,n,N,MCMC_m,P_a);
[F1]=resu_B(w_true,w,N)
M=length(w)

%没有熵排序
w=algorithm_no_min_entropy(S,n,N,MCMC_m,P_a);
[F1]=resu_B(w_true,w,N)
M=length(w)
%最大后验
w=algorithm_max(S,n,N,MCMC_m);
[F1]=resu_B(w_true,w,N)
M=length(w)
%没有贝叶斯
w=algorithm_no_beyes(S,n,N,MCMC_m,P_a);
[F1]=resu_B(w_true,w,N)
M=length(w)
%基于最大熵的贝叶斯方法
w=algorithm_no_distribution(S,n,N,MCMC_m);
[F1]=resu_B(w_true,w,N)
M=length(w)
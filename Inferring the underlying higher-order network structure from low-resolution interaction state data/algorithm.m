function w=algorithm(S,n,N,MCMC_m,P_a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入：时间序列S，一致超图阶数n，节点数N，MCMC序列长度MCMC_m
%输出：重构网络w

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[P,P_dl]=inniti_P(S,n,N);%初始化概率矩阵


sample_n=100;%抽取重构网络的数量
sample_r=10;%保留原来样本的数量
sample_min=50;%选取边数最小的重构网络的数量(sample_min<=sample_n)
iteration_j=10;%迭代的次数


T=length(S);%时间步长
wall=cell(1,iteration_j);%记录每次迭代边数最少的网络
wall_t=zeros(size(P,1),sample_r);%记录上次迭代重构网络样本
wall_t_side=zeros(1,sample_r);%记录上次迭代重构网络样本边数
wall_i=zeros(size(P,1),sample_n);%记录当前迭代重构网络样本
wall_side=zeros(1,sample_n);%记录当前迭代重构网络的边数
H_allconfig=cell(1,T);%存储上次迭代每个时间段构型


 for j=1:iteration_j    
     %对每个时间段进行MCMC抽样
     [H_config,H_config_dl,d]=MCMC(S,P,N,MCMC_m,H_allconfig,P_dl,n);
     H_allconfig=H_config;        
     %抽取重构网络的样本
     for i=1:sample_n
        %重构的网络样本和边数
        wall_i(:,i)=sample_nx(H_config,H_config_dl,d,P);
        wall_side(i)=length(find(wall_i(:,i)));
     end
     
     [~,d]=sort(wall_side);%根据网络边数从小到大排列
     %用上次迭代的部分样本替换当前迭代的样本
     if j~=1
         wall_i(:,d(end-sample_r+1:end))=wall_t;
         wall_side(d(end-sample_r+1:end))=wall_t_side;
         [~,d]=sort(wall_side);
     end      
     wall{j}=P(wall_i(:,d(1))~=0,1);
     
     %判断终止条件
     % if j>=2&&length(wall{j})==length(wall{j-1})&&sum(wall{j}-wall{j-1})==0
     %     break;   
     % end
     
     %记录上次迭代重构网络样本
     wall_t(:,1:sample_r)=wall_i(:,d(1:sample_r));
     wall_t_side(1:sample_r)=wall_side(d(1:sample_r));
     %取前sample_min个边数最小的网络更新概率矩阵
     w_minsum=sum(wall_side(d(1:sample_min)));     
     P(:,2)=(1-P_a)*P(:,2)+P_a*sum(wall_i(:,d(1:sample_min)),2)/w_minsum;
 end
 w=wall{j};
 
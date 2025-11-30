function [H_config,H_config_dl,d]=MCMC(S,P,N,MCMC_m,H_allconfig,P_dl,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入：
%S:时间序列
%P:概率矩阵
%N:节点个数
%MCMC_m：采样序列长度
%H_allconfig:上次迭代每个时间段构型
%P_dl:每个时间段所有边的位置
%n:一致超图阶数
%输出:
%H_config：每个时间段构型
%H_config_dl:每个时间段边的位置
%d：时间段抽样顺序

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=length(S);%时间步长
H_config=cell(1,T);%存储每个时间段构型
H_config_dl=cell(1,T);%存储每个时间段边的位置
H_config_S=zeros(1,T);%存储每个时间段的构型概率的熵
sample=cell(1,MCMC_m);%存储采样样本



%对每个时间段构型进行采样并求出每个构型概率存储在H_config
for i=1:T
    MCMC_n=[];%从总样本中选择第n到第m个样本求概率
    L=length(S{i});%时间段i活跃节点数
    
    %时间序列起始构型
    [sample{1},x1]=star_x(P,P_dl{i},S{i},N,n);  
    
    %抽取MCMC_m个构型样本
    for j=2:MCMC_m
        [x1,sample{j},trans]=sfor_s(L/n,x1,sample{j-1},P,P_dl{i},N,n);
        if isempty(MCMC_n)&&trans==1
            MCMC_n=j;
        end
    end
    if isempty(MCMC_n)
        MCMC_n=MCMC_m;
        x1=reshape(S{i},L/n,n);
        sample{MCMC_m}=sum(N.^(0:n-1).*(x1-1),2)+1;
    end
    
    %取第sample_n个到第sample_m个构型样本，然后求每种构型的概率
    H_sample=sort(cell2mat(sample(MCMC_n:MCMC_m)))';
    H_sample=[H_sample;H_allconfig{i}];
    H_config{i}=unique(H_sample,'rows');%时间段i的每种构型
    x=H_config{i}';
    y=x(:)';
    dl=find(P_dl{i}(:,1)==y);
    if size(dl,1)==1
        dl=dl';
    end
    dl=dl'-(0:length(y)-1)*size(P_dl{i},1);
    dl=P_dl{i}(dl,2);
    H_config_dl{i}=dl;
    HS=prod(reshape(P(dl,2),size(x)))';%时间段i每种构型的概率
    HS=HS/sum(HS);
    H_config_S(i)=sum(-HS.*log2(HS+10^-100));%求熵
end
[~,d]=sort(H_config_S);%按熵的大小排列时间段
%d=1:T;                %没有不确定排序
end

function [sample,x1]=star_x(P,P_dli,S_i,N,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%生成时间序列起始构型
%输入：交互概率P,位置P_dli,时间序列S_i
%节点N,阶数n
%输出：起始构型sample，下标x1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,d]=max(P(P_dli(:,2),2));
side_p=P(P_dli(d,2),3:end);
for j=1:n
    d=find(S_i==side_p(j));
    S_i(d(1))=[];
end

while ~isempty(S_i)
    Hc_a=S_i(allside(n,length(S_i)));
    Hc_ad=sum(N.^(0:n-1).*(Hc_a-1),2)+1;
    Hc_adp=[];
    
    for j=1:length(Hc_ad)
        aa=find(P(:,1)==Hc_ad(j));
        if ~isempty(aa)
            Hc_adp=[Hc_adp;P(aa,2)];
        else
            Hc_adp=[Hc_adp;0];
        end
    end
    [~,d]=max(Hc_adp);
    side_p=[side_p;Hc_a(d,:)];
    for j=1:n
        dd=find(S_i==Hc_a(d,j));
        S_i(dd(1))=[];
    end
end
sample=sum(N.^(0:n-1).*(side_p-1),2)+1;
x1=side_p;
end

function [x2,sample_f,trans]=sfor_s(k,x1,sample_o,P,P_dli,N,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%生成新构型
%输入：构型边数k,原构型x1,下标sample_o,交互概率P
%位置P_dli,节点数N，阶数n
%输出：新构型x2，下标sample_f,是否转移trans

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

side=fix(rand()*k+1);%side为要转移的构型改变的边数
if side~=1
    %从上个样本中随机选择side个交互进行打乱
    d=randperm(length(sample_o));
    side_p=x1(d(1:side),:);%要抹去交互信息的边
    side_p=sort(side_p(reshape(randperm(side*n),side,n)),2);
    x2=x1;
    x2(d(1:side),:)=side_p;
    %转化后构型下标
    x2_id=sum(N.^(0:n-1).*(x2-1),2)+1;
    [sample_f,x2,trans]=transfer(sample_o,x2_id,x1,x2,P,k,P_dli);
else
    %side如果为1说明不改变构型
    sample_f=sample_o;
    x2=x1;
    trans=0;
end
end

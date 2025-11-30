function w_i=sample_nx(H_config,H_config_dl,d,P)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入：
%H_config：每个时间段构型
%config_dl:每个时间段边的位置
%d：时间段抽样顺序
%P:概率矩阵

%输出：
%w_i：重构的网格样本

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P=P(:,2);%初始概率
w_i=zeros(length(P),1);%记录时间段d已选构型的网格
lamta=10^-10;%极小值
%lamta=1；    没有贝叶斯网络


for i=1:length(d)
    dl=reshape(H_config_dl{d(i)},size(H_config{d(i)}'));
    P_s=P(dl);%初始时刻选集中构型的概率
    D_t=w_i(dl);%在t时刻已选构型的概率
    P_t=lamta.*P_s+(1-lamta).*D_t;
    %在t时刻候选集中构型的概率
    P_t=max(prod(P_t,1),10^(-300));
    P_t=P_t/max(sum(P_t),10^(-300));
    %按概率抽取时间段的构型
    if ~isempty(H_config{d(i)})
        x=randsrc(1,1,[1:size(H_config{d(i)},1);(P_t)]);
        %[~,x]=max(P_t);
        dl=dl(:,x);
        w_i(dl)=w_i(dl)+1;
    end
end

w_i(w_i(:)~=0)=1;

end
    
    



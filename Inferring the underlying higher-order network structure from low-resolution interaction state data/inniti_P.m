function [P,P_dl]=inniti_P(S,n,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%初始化概率矩阵
%输入：时序数据S,阶数n
%输出：初始交互概率P，位置P_dl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P=zeros(1,n+2);
P_dl=cell(1,length(S));%储存每个时间段所有边的位置
for i=1:length(S)
    P_i=zeros(1,2);
    L=length(S{i});
    P_side=S{i}(allside(n,L));
    for j=1:size(P_side,1)
        m=P_side(j,:);
        if length(unique(m))==n
            side_id=sum(N.^(0:n-1).*(m-1),2)+1;
            d=find(P(:,1)==side_id);
            if ~isempty(d)
                P(d,2)=P(d,2)+1;
                P_i=[P_i;side_id,d-1];
            else
                P=[P;[side_id,1,m]];
                P_i=[P_i;side_id,size(P,1)-1];
            end
        end
    end
    P_i(1,:)=[];
    P_i=unique(P_i,'rows');
    P_dl{i}=P_i;
end
P(1,:)=[];
P(:,2)=P(:,2)/sum(P(:,2));
function P_side=allside(n,L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入：
%n:一致超图阶数
%L:活跃节点个数

%输出：
%P_side:所有可能的边

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P_side=(1:L-n+1)';
for i=2:n
    P_i=[];
    for j=1:size(P_side,1)
        P_j=(P_side(j,i-1)+1:L-n+i)';
        P_j=[repmat(P_side(j,:),length(P_j),1),P_j];
        P_i=[P_i;P_j];
    end
    P_side=P_i;
end

function [S,w_true,w]=WS(N,M,T,k,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入：
%N:节点数
%M:边数
%T:时间序列长度
%k:每个时间段边数
%n:一致超图阶数

%输出：
%S:时间序列
%w_ture:底层网络

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p=0.5;
m=M/N;
S=cell(1,T); %每个时间步的活跃节点
w=zeros(1,n);%生成网络


%生成WS网络
for i=0:N-1
    for j=1:m
       w=[w;[i,mod(i+j,N)]];
       w=[w;[i,mod(N+i-j,N)]];
    end
end
w(1,:)=[];
w=w+1;
w=sort(w,2);
w=unique(w,'rows');


for i=1:M
    u=rand;
    if u>=p
        x=ceil(N*rand);
        while ~isempty(find(sum(w==sort([w(i,1),x]),2)==2, 1))||x==w(i,1)
            x=ceil(N*rand);
        end
        w(i,2)=x;
        w=sort(w,2);
    end
end
w=unique(w,'rows');

% %从生成的边中每个时间步随机抽取k条边
w_true=sum(N.^(0:n-1).*(w-1),2)+1;
v=ceil(k*T/M);
w_v=repmat(w,[v,1]);
r=randperm(k*T); 
w_v=w_v(r,:); %扰乱
for i=1:T
    dd=w_v(k*(i-1)+1:k*i,:);
    S{i}=sort(dd(:))'; 
end  
w=unique(w,'rows');
w_true=unique(w_true);

function [S,w_true,w]=ER(N,M,T,k,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入：
%N:节点数
%M:边数
%T:时间序列长度;只要k*T>M就能遍历所有的边
%k:每个时间段边数
%n:一致超图阶数

%输出：
%S:时间序列
%w_ture:底层网络

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S=cell(1,max(T)); %每个时间步的活跃节点
w=zeros(1,n);%生成网络


%生成ER网络
for i=1:M
    r=randperm(N);
    r=sort(r(1:n));    
    %如果生成的边已经存在则重新生成
    while ~isempty(find(sum(r==w,2)==n, 1))
       r=randperm(N);
       r=sort(r(1:n));
    end
    w=[w;r];
end
w(1,:)=[];

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





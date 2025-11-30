function [S,k]=InVS13_2(s)




filename='InVS13.xlsx';
[~,~,data]=xlsread(filename,'A1:C9827');
A=reshape(cell2mat(data),length(data),3);
min_A=min(A(:,1));
max_A=max(A(:,1));
k=[];
S=[];
S1=[];
w_true=[];%µ×²ãÍøÂç

for i=min_A:s:max_A
    d=A(A(:,1)>=i&A(:,1)<i+s,2:3);
    d=unique(sort(d,2),'rows');
    S=[S;d];
    k=[k,size(d,1)];
end
k(k==0)=[];

j=1;
min_j=min(S(:));
max_j=max(S(:));
for i=min_j:max_j
    d=(S==i);
    if sum(d(:))~=0
        S(d)=j;
        j=j+1;
    end    
end






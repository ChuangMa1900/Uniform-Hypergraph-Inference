function [S,k]=Village_3(s)


filename='village.xlsx';
[~,~,data]=xlsread(filename,'A1:C102293');
A=reshape(cell2mat(data),length(data),3);
min_A=min(A(:,1));
max_A=max(A(:,1));
k=[];
S=[];
S1=[];
w_true=[];%µ×²ãÍøÂç

for i=min_A:20:max_A
    d=A(A(:,1)>=i&A(:,1)<i+20,2:3);
    d=unique(sort(d,2),'rows');
    for j=1:size(d,1)
        for z=j+1:size(d,1)
            dd=unique([d(j,:),d(z,:)]);
            if length(dd)==3
                d1=find(~sum(d(j,:)'==d(z,:),2));
                d2=find(~sum(d(j,:)'==d(z,:),1));
                if ~isempty(find(sum(sort([d(j,d1),d(z,d2)])==d,2)==2, 1))
                    S1=[S1;dd];
                end
            end
        end       
    end
    S1=unique(S1,'rows');
    kk=size(S1,1);
    S=[S;S1];
    S1=[];
    k=[k,kk];
end
k(k==0)=[];

x=s/20;
k1=[];
for i=1:x:length(k)
    d=sum(k(i:min(i+x-1,length(k))));
    k1=[k1,d];
end
k=k1;    




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






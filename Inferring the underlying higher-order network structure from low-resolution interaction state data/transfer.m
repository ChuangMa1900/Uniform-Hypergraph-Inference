function [x1_id,x1,trans]=transfer(x1_id,x2_id,x1,x2,P,k,P_dl_i)
%输入:
%x1_id：原来的构型下标 
%x1：原来的构型 
%x2_id：转换后的构型下标
%x2：转换后的构型
%k:每个时间段超边数
%P_dl_i:第i时间段构型的位置


%输出：
%x_id:作为样本的构型下标
%x1:作为样本的构型
%trans:是否转移标志

trans=0;
dl=find(P_dl_i(:,1)==x2_id');
if size(dl,1)==1
    dl=dl';
end
if length(dl)==k        
    dl=dl'-(0:length(dl)-1)*size(P_dl_i,1);
    dl=P_dl_i(dl,2);
    P2=prod(P(dl,2));%转移构型概率
    if isempty(find(sum(x2_id==x2_id')>=2, 1))%判断是否有重边
        trans=1;
        dl=find(P_dl_i(:,1)==x1_id');
        if size(dl,1)==1
            dl=dl';
        end
        if length(dl)==k
            dl=dl'-(0:length(dl)-1)*size(P_dl_i,1);
            dl=P_dl_i(dl,2);
            P1=prod(P(dl,2));%原构型概率
            alpha=min(1,P2/P1);%接受分布
            u=rand();
            if u<=alpha
                x1_id=x2_id;
                x1=x2;               
            end
        else
            x1_id=x2_id;
            x1=x2;
        end
    end
end

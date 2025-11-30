function [F1]=resu_B(w_true,w,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算指标
%输入：真实矩阵w_true，重构矩阵w，节点数N
%输出：F1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=length(w_true);%真实的边数
n=length(w);%预测边数
a=length(unique([w_true;w]));%非重复边数
fp=a-m;%多预测的边
tp=n-fp;%预测对的边
recall=tp/m;  %召回率
percision=tp/(tp+fp); %精度
F1=2/(1/recall+1/percision);

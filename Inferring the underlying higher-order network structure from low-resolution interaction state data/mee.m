function result1=mee(R1)

B=mean(R1,1);
C=std(R1,1);
result1=[B',C'];
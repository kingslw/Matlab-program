%多元散射校正
%输入待处理矩阵，通过多元散射校正，求得校正后的矩阵,每个样本的斜率k，截距b
clc;clear;
data=xlsread('data.xlsx');
[p,q] = size(data);
A=data(:,2:q);

%获得矩阵行列数
[m,n] = size(A);

%求平均光谱
M = mean(A,2);

%利用最小二乘法求每一列的斜率k和截距b
for i = 1:n
    a = polyfit(M,A(:,i),1);
if i == 1
    k = a(1);
    b = a(2);
else
    k = [k,a(1)];
    b = [b,a(2)];
 end
end

%求得结果
for i = 1:n
    Ai = (A(:,i)-b(i))/k(i);
    if i == 1
        R = Ai;
    else
        R = [R,Ai];
     end
end

r=[data(:,1),R];
xlswrite('result',r);



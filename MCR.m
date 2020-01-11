%��Ԫɢ��У��
%������������ͨ����Ԫɢ��У�������У����ľ���,ÿ��������б��k���ؾ�b
clc;clear;
data=xlsread('data.xlsx');
[p,q] = size(data);
A=data(:,2:q);

%��þ���������
[m,n] = size(A);

%��ƽ������
M = mean(A,2);

%������С���˷���ÿһ�е�б��k�ͽؾ�b
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

%��ý��
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



%读取表格中的数据-----------------------------------------------------------                               
clear;
clc;
a=xlsread('FISHERcenter.xls'); 
U=xlsread('FISHERdistinguish.xls');
u1=U(:,1);u2=U(:,2);u3=U(:,3);
data=xlsread('PCAresult.xls'); 

%验证每一个数据-------------------------------------------------------------
first_x = data(:,:)*u1;
second_y = data(:,:)*u2;
third_z = data(:,:)*u3;
[n,m]=size(data);
temp=[];
for i=1:n
    s1=sqrt((first_x(i,1)-a(1,1))^2+(second_y(i,1)-a(1,2))^2+(third_z(i,1)-a(1,3))^2);
    s2=sqrt((first_x(i,1)-a(2,1))^2+(second_y(i,1)-a(2,2))^2+(third_z(i,1)-a(2,3))^2);
    s3=sqrt((first_x(i,1)-a(3,1))^2+(second_y(i,1)-a(3,2))^2+(third_z(i,1)-a(3,3))^2);
    tempmat=[s1,s2,s3];temp=[temp;tempmat];
end                           %temp里按行存放每一个样本到三类中心的距离

classxls=[];
for i=1:n
    mins=min(temp(i,:));
    if mins==temp(i,1)
       classxls=[classxls;1]; 
    elseif mins==temp(i,2)
       classxls=[classxls;2];
    elseif mins==temp(i,3)
       classxls=[classxls;3];
    end
end 
result=[temp,classxls];

%写入结果------------------------------------------------------------------
xlswrite('DISTINGUISHresult',result);



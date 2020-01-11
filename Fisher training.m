% 读取PCA的结果数据---------------------------------------------------------                        
clear;
clc;
data=xlsread('PCAresult.xls'); 
data=data(1:120,:);

% 提取三类样本--------------------------------------------------------------
x1=data(1:40,:);
x2=data(41:80,:);
x3=data(81:120,:);

% 求各类样本的均值----------------------------------------------------------
mean_x1=mean(x1);
mean_x2=mean(x2);
mean_x3=mean(x3);

% 分别求各类样本的协方差----------------------------------------------------
cov_x1=cov(x1);
cov_x2=cov(x2);
cov_x3=cov(x3);

% 构造总样本均值矩阵--------------------------------------------------------
M=[mean_x1;mean_x2;mean_x3];

% 求Sw,Sb------------------------------------------------------------------
[m,n]=size(M);
I=eye(m);
J=ones(m);
Sb=M'*(I-J./m)*M;
V=cov_x1+cov_x2+cov_x3;
Sw=m*V;
[U,D]=eig(inv(Sw)*Sb);

% 投影---------------------------------------------------------------------
u1=U(:,1);
u2=U(:,2);
u3=U(:,3);

% 计算各样本在x,y,z轴上得分-------------------------------------------------
first_x = data(:,:)*u1;
second_y = data(:,:)*u2;
third_z = data(:,:)*u3;

%作图----------------------------------------------------------------------
scatter3(first_x(1:40,1),second_y(1:40,1),third_z(1:40,1),'k*');hold on;
scatter3(first_x(41:80,1),second_y(41:80,1),third_z(41:80,1),'or');
scatter3(first_x(81:120,1),second_y(81:120,1),third_z(81:120,1),'bp');

%计算各类样本中心点坐标-----------------------------------------------------
center_1x=mean_x1*u1;center_1y=mean_x1*u2;center_1z=mean_x1*u3;
center_2x=mean_x2*u1;center_2y=mean_x2*u2;center_2z=mean_x2*u3;
center_3x=mean_x3*u1;center_3y=mean_x3*u2;center_3z=mean_x3*u3;

%写入结果------------------------------------------------------------------
a=[center_1x,center_1y,center_1z;center_2x,center_2y,center_2z;center_3x,center_3y,center_3z];
xlswrite('FISHERcenter.xls',a);
u4=[u1,u2,u3];
xlswrite('FISHERdistinguish.xls',u4);

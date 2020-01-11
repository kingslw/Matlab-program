% 读取PCA的结果数据---------------------------------------------------------                        
clear;
clc;
data=xlsread('PCAresult.xls'); 
data=data(1:120,:);

%分别验证------------------------------------------------------------------
temp=[];
for i=1:120
    if i==1
        x1=data(2:40,:);x2=data(41:80,:);x3=data(81:120,:);xtest=data(i,:);
    elseif i>1&&i<40
        x1=[data(1:i-1,:);data(i+1:40,:)];x2=data(41:80,:);x3=data(81:120,:);xtest=data(i,:);
    elseif i==40
        x1=data(1:39,:);x2=data(41:80,:);x3=data(81:120,:);xtest=data(i,:);    
    elseif i==41
        x1=data(1:40,:);x2=data(42:80,:);x3=data(81:120,:);xtest=data(i,:);    
    elseif i>41&&i<80
        x1=data(1:40,:);x2=[data(41:i-1,:);data(i+1:80,:)];x3=data(81:120,:);xtest=data(i,:);   
    elseif i==80
        x1=data(1:40,:);x2=data(41:79,:);x3=data(81:120,:);xtest=data(i,:);    
    elseif i==81
        x1=data(1:40,:);x2=data(41:80,:);x3=data(82:120,:);xtest=data(i,:);        
    elseif i>81&&i<120
        x1=data(1:40,:);x2=data(41:80,:);x3=[data(81:i-1,:);data(i+1:120,:)];xtest=data(i,:);
    elseif i==120
        x1=data(1:40,:);x2=data(41:80,:);x3=data(81:119,:);xtest=data(i,:);
    end
    
    mean_x1=mean(x1);mean_x2=mean(x2);mean_x3=mean(x3);%求各类训练样本均值
    cov_x1=cov(x1);cov_x2=cov(x2);cov_x3=cov(x3);%求各类训练样本协方差
    M=[mean_x1;mean_x2;mean_x3];%构造总样本均值矩阵
    [m,n]=size(M);I=eye(m);J=ones(m);Sb=M'*(I-J./m)*M;V=cov_x1+cov_x2+cov_x3;Sw=m*V;[U,D]=eig(inv(Sw)*Sb);% 求Sw,Sb
    u1=U(:,1);u2=U(:,2);u3=U(:,3);%投影
    center_1x=mean_x1*u1;center_1y=mean_x1*u2;center_1z=mean_x1*u3;
    center_2x=mean_x2*u1;center_2y=mean_x2*u2;center_2z=mean_x2*u3;
    center_3x=mean_x3*u1;center_3y=mean_x3*u2;center_3z=mean_x3*u3; %计算各类样本中心点坐标
    
    xtest_x=xtest*u1;xtest_y=xtest*u2;xtest_z=xtest*u3;%测试样本作投影
    
    s1=sqrt((xtest_x-center_1x)^2+(xtest_y-center_1y)^2+(xtest_z-center_1z)^2);
    s2=sqrt((xtest_x-center_2x)^2+(xtest_y-center_2y)^2+(xtest_z-center_2z)^2);
    s3=sqrt((xtest_x-center_3x)^2+(xtest_y-center_3y)^2+(xtest_z-center_3z)^2);
    tempmat=[s1,s2,s3];temp=[temp;tempmat];
end

classxls=[];
for i=1:120
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
xlswrite('VALIDATEresult',result);

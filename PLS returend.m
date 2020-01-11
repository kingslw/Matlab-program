clc % 清屏
clear all; % 删除workplace变量
close all; % 关掉显示图形窗口
format short
load('mydata.mat')

ch0=repmat(ch0,num,1);%repmat起复制矩阵组合为新矩阵的作用
yhat=ch0+x0*xish; %计算y 的预测值
y1max=max(yhat);
y2max=max(y0);
ymax=max([y1max;y2max]);

figure
plot(0:ymax(1),0:ymax(1)); hold on;
plot(yhat(1:35,1),y0(1:35,1),'*');
plot(yhat(36:70,1),y0(36:70,1),'+');
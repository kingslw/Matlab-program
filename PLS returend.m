clc % ����
clear all; % ɾ��workplace����
close all; % �ص���ʾͼ�δ���
format short
load('mydata.mat')

ch0=repmat(ch0,num,1);%repmat���ƾ������Ϊ�¾��������
yhat=ch0+x0*xish; %����y ��Ԥ��ֵ
y1max=max(yhat);
y2max=max(y0);
ymax=max([y1max;y2max]);

figure
plot(0:ymax(1),0:ymax(1)); hold on;
plot(yhat(1:35,1),y0(1:35,1),'*');
plot(yhat(36:70,1),y0(36:70,1),'+');
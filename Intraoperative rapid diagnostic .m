clc;clear;warning off;
folder = 'test\';files = dir([folder '*.bmp']);

mkdir('data1');mkdir('data2');%�½�data1��data2�ļ���������ʱ�������
lengthnum=length(files);

%ӫ��α�ʴ��������������data1�ļ�����--------------------------------------
for i = 1 : lengthnum
    bgFile1=['data1\',int2str(i),'.jpg'];
    oldname = files(i).name;    
    a = imread(strcat(folder,oldname));
    imageorg=imresize(a,[1000,1333]);
    grayImage=rgb2gray(imageorg);
    grayImage=histeq(grayImage,256);
    grayImage=medfilt2(grayImage);
    G2C=grayslice(grayImage,128);%�ܶȷָ�
    h=imshow(G2C,jet(128));
    saveas(h,bgFile1);
end

%��α��ͼ����Ϊ�ʺ�CNN���紦��ĳߴ粢�����data2�ļ�����----------------------
for i=1:lengthnum
    bgFile2 = ['data1\',int2str(i),'.jpg'];
    bgFile3 = ['data2\',int2str(i),'.jpg'];
    I=imread(bgFile2);
    A=imcrop(I,[140 50 1030 1030]);
    nameh=[int2str(i),'.jpg'];
    imwrite(A,bgFile3);
end

% �ͷſռ�������������Կ�Ҫ��-----------------------------------------------
save data lengthnum;
clear;
load GooGLeNet net;inputSize = net.Layers(1).InputSize;
load data.mat;

%��CNN���������Ʒ����-------------------------------------------------------             
imdspredic = imageDatastore('data2','IncludeSubfolders',true,'LabelSource','foldernames');
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdspredic);
[YPred,probs] = classify(net,augimdsValidation);

%ͳ�Ƽ�����---------------------------------------------------------------
healthynum=0;cancernum=0;healthychar='healthy';cancerchar='cancer';
for i=1:lengthnum
    if YPred(i,:)==healthychar
        healthynum=healthynum+1;
    end
    if YPred(i,:)==cancerchar
        cancernum=cancernum+1;
    end
end

%������-------------------------------------------------------------------
procancer=cancernum/lengthnum*100;
T1=['������������Ϊ  ',int2str(healthynum)];
T2=['��֢��������Ϊ  ',int2str(cancernum)];
T3=['����������Ϊ  ',int2str(procancer),'%'];

if procancer>=85
    T4='ȷ��Ϊ��֢';
elseif procancer<85&&procancer>=70
    T4='����Ϊ��֢';
elseif procancer<=30&&procancer>15
    T4='����Ϊ����';
elseif procancer<=15&&procancer>=0
    T4='ȷ��Ϊ����';
else
    T4='�޷��ж�';
end
T4=['��Ͻ��Ϊ��',T4];

disp(T1);disp(T2);disp(T3);disp(T4);

%ɾ���ݴ����ݵ�data1��data2�ļ���--------------------------------------------
rmdir('data1','s');
rmdir('data2','s');
delete data.mat;





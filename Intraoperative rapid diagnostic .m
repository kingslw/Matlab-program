clc;clear;warning off;
folder = 'test\';files = dir([folder '*.bmp']);

mkdir('data1');mkdir('data2');%新建data1和data2文件夹用于暂时存放数据
lengthnum=length(files);

%荧光伪彩处理并重命名存放在data1文件夹下--------------------------------------
for i = 1 : lengthnum
    bgFile1=['data1\',int2str(i),'.jpg'];
    oldname = files(i).name;    
    a = imread(strcat(folder,oldname));
    imageorg=imresize(a,[1000,1333]);
    grayImage=rgb2gray(imageorg);
    grayImage=histeq(grayImage,256);
    grayImage=medfilt2(grayImage);
    G2C=grayslice(grayImage,128);%密度分割
    h=imshow(G2C,jet(128));
    saveas(h,bgFile1);
end

%将伪彩图剪切为适合CNN网络处理的尺寸并存放在data2文件夹下----------------------
for i=1:lengthnum
    bgFile2 = ['data1\',int2str(i),'.jpg'];
    bgFile3 = ['data2\',int2str(i),'.jpg'];
    I=imread(bgFile2);
    A=imcrop(I,[140 50 1030 1030]);
    nameh=[int2str(i),'.jpg'];
    imwrite(A,bgFile3);
end

% 释放空间以满足低性能显卡要求-----------------------------------------------
save data lengthnum;
clear;
load GooGLeNet net;inputSize = net.Layers(1).InputSize;
load data.mat;

%用CNN网络鉴别样品类型-------------------------------------------------------             
imdspredic = imageDatastore('data2','IncludeSubfolders',true,'LabelSource','foldernames');
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdspredic);
[YPred,probs] = classify(net,augimdsValidation);

%统计鉴别结果---------------------------------------------------------------
healthynum=0;cancernum=0;healthychar='healthy';cancerchar='cancer';
for i=1:lengthnum
    if YPred(i,:)==healthychar
        healthynum=healthynum+1;
    end
    if YPred(i,:)==cancerchar
        cancernum=cancernum+1;
    end
end

%输出结果-------------------------------------------------------------------
procancer=cancernum/lengthnum*100;
T1=['健康样本数量为  ',int2str(healthynum)];
T2=['癌症样本数量为  ',int2str(cancernum)];
T3=['患癌可能性为  ',int2str(procancer),'%'];

if procancer>=85
    T4='确诊为癌症';
elseif procancer<85&&procancer>=70
    T4='怀疑为癌症';
elseif procancer<=30&&procancer>15
    T4='怀疑为健康';
elseif procancer<=15&&procancer>=0
    T4='确诊为健康';
else
    T4='无法判断';
end
T4=['诊断结果为：',T4];

disp(T1);disp(T2);disp(T3);disp(T4);

%删除暂存数据的data1和data2文件夹--------------------------------------------
rmdir('data1','s');
rmdir('data2','s');
delete data.mat;





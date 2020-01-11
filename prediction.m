% ��ʼ��--------------------------------------------------------------------
clc;clear all;
load GooGLeNet net;inputSize = net.Layers(1).InputSize;                 
imdspredic = imageDatastore('PredictionData','IncludeSubfolders',true,'LabelSource','foldernames');
T = countEachLabel(imdspredic);disp(T);

% ����֤ͼ����з���---------------------------------------------------------
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdspredic);
[YPred,probs] = classify(net,augimdsValidation); %��������YPred�У�probsΪ������
testLabels = imdspredic.Labels; 
accuracy = sum(YPred == testLabels)/numel(YPred);
disp(['accuracy:',num2str(accuracy)]); % ���Ԥ�⾫�Ƚ��

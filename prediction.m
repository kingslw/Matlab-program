% 初始化--------------------------------------------------------------------
clc;clear all;
load GooGLeNet net;inputSize = net.Layers(1).InputSize;                 
imdspredic = imageDatastore('PredictionData','IncludeSubfolders',true,'LabelSource','foldernames');
T = countEachLabel(imdspredic);disp(T);

% 对验证图像进行分类---------------------------------------------------------
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdspredic);
[YPred,probs] = classify(net,augimdsValidation); %结果存放在YPred中，probs为错误率
testLabels = imdspredic.Labels; 
accuracy = sum(YPred == testLabels)/numel(YPred);
disp(['accuracy:',num2str(accuracy)]); % 输出预测精度结果

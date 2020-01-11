% 初始化--------------------------------------------------------------------
clc;clear all;
net = googlenet;                               %建立googlenet
inputSize = net.Layers(1).InputSize;                     %得到输入层大小
imdsTrain = imageDatastore('TrainingData','IncludeSubfolders',true,'LabelSource','foldernames');
T = countEachLabel(imdsTrain);disp(T);                   %读取并显示训练集
imdspredic = imageDatastore('PredictionData','IncludeSubfolders',true,'LabelSource','foldernames');
P = countEachLabel(imdspredic);disp(P);                  %读取并显示预测集

% 完成新网络配置------------------------------------------------------------
lgraph = layerGraph(net);                                %将net转化为相互连接的图层存放
lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});   
                                                         %去掉最末尾三层
numClasses = numel(categories(imdsTrain.Labels));    
                                                         %计算一下训练集有几类
newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    % 权重学习率的乘数为10，偏差学习率的乘数为10
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];          %配置最后三层
lgraph = addLayers(lgraph,newLayers);   
lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fc'); %将前面的层与自定的后三层连接起来
layers = lgraph.Layers;connections = lgraph.Connections;
layers(1:110) = freezeWeights(layers(1:110));            %冻结前110图层，使其不变
lgraph = createLgraphUsingConnections(layers,connections); %并使所有图层连接起来

 

% 训练并保存新网络----------------------------------------------------------
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( 'RandXReflection',true,'RandXTranslation',pixelRange,'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain,'DataAugmentation',imageAugmenter);
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdspredic);
%样本参数设置2
options = trainingOptions('sgdm','MiniBatchSize',32,'MaxEpochs',22,'InitialLearnRate',0.0018,'ValidationData',augimdsValidation,...
    'ValidationFrequency',3,'ValidationPatience',Inf,'Verbose',false ,'Plots','training-progress');
%训练参数设置
%梯度下降法；每次迭代最小批量为20；训练遍历次数为6；初始学习率为0.0001；
% 验证度量评估的迭代次数为3；允许丢失次数为inf；不显示训练进度；显示训练图表
net = trainNetwork(augimdsTrain,lgraph,options);          %训练新网络
[YPred,probs] = classify(net,augimdsValidation);          %结果存放在YPred中，probs为错误率
testLabels = imdspredic.Labels; accuracy = sum(YPred == testLabels)/numel(YPred);
disp(['accuracy:',num2str(accuracy)]); % 输出预测精度结果
save GooGLeNet net;
 


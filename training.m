% ��ʼ��--------------------------------------------------------------------
clc;clear all;
net = googlenet;                               %����googlenet
inputSize = net.Layers(1).InputSize;                     %�õ�������С
imdsTrain = imageDatastore('TrainingData','IncludeSubfolders',true,'LabelSource','foldernames');
T = countEachLabel(imdsTrain);disp(T);                   %��ȡ����ʾѵ����
imdspredic = imageDatastore('PredictionData','IncludeSubfolders',true,'LabelSource','foldernames');
P = countEachLabel(imdspredic);disp(P);                  %��ȡ����ʾԤ�⼯

% �������������------------------------------------------------------------
lgraph = layerGraph(net);                                %��netת��Ϊ�໥���ӵ�ͼ����
lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});   
                                                         %ȥ����ĩβ����
numClasses = numel(categories(imdsTrain.Labels));    
                                                         %����һ��ѵ�����м���
newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    % Ȩ��ѧϰ�ʵĳ���Ϊ10��ƫ��ѧϰ�ʵĳ���Ϊ10
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];          %�����������
lgraph = addLayers(lgraph,newLayers);   
lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fc'); %��ǰ��Ĳ����Զ��ĺ�������������
layers = lgraph.Layers;connections = lgraph.Connections;
layers(1:110) = freezeWeights(layers(1:110));            %����ǰ110ͼ�㣬ʹ�䲻��
lgraph = createLgraphUsingConnections(layers,connections); %��ʹ����ͼ����������

 

% ѵ��������������----------------------------------------------------------
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( 'RandXReflection',true,'RandXTranslation',pixelRange,'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain,'DataAugmentation',imageAugmenter);
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdspredic);
%������������2
options = trainingOptions('sgdm','MiniBatchSize',32,'MaxEpochs',22,'InitialLearnRate',0.0018,'ValidationData',augimdsValidation,...
    'ValidationFrequency',3,'ValidationPatience',Inf,'Verbose',false ,'Plots','training-progress');
%ѵ����������
%�ݶ��½�����ÿ�ε�����С����Ϊ20��ѵ����������Ϊ6����ʼѧϰ��Ϊ0.0001��
% ��֤���������ĵ�������Ϊ3������ʧ����Ϊinf������ʾѵ�����ȣ���ʾѵ��ͼ��
net = trainNetwork(augimdsTrain,lgraph,options);          %ѵ��������
[YPred,probs] = classify(net,augimdsValidation);          %��������YPred�У�probsΪ������
testLabels = imdspredic.Labels; accuracy = sum(YPred == testLabels)/numel(YPred);
disp(['accuracy:',num2str(accuracy)]); % ���Ԥ�⾫�Ƚ��
save GooGLeNet net;
 


%读取表格中的数据-----------------------------------------------------------                               
clear;
clc;
a=xlsread('data.xlsx'); 

%以下是PCA计算过程----------------------------------------------------------
[n,m]=size(a);
temp=[];
for i=1:n
    tempmat=a(i,1:m);
	tempmat=tempmat-min(tempmat)+ones(1,m);
	temp=[temp;tempmat];
end                                                     %矩阵变正

[coeff,score,latent,tsquare]=pca(temp);            %PCA

latents=100*latent/sum(latent);                         %计算贡献率

%作贡献率图-----------------------------------------------------------------
figure;
sumtemp=0;b=[];
for i=1:10
    latentstemp=latents(i,1);
    sumtemp=sumtemp+latentstemp;
    b=[b;latentstemp,sumtemp];
end
bar(b,1);hold on;
line([0,10.5],[85,85]);
legend('贡献率','累计贡献率');
xlabel('主成分');ylabel('贡献率(%)');
text(0.5,87,'85%');
suptitle('主成分贡献率图');

figure;hold on;
scatter3(score(1:6,1),score(1:6,2),score(1:6,3),'*');
scatter3(score(7:12,1),score(7:12,2),score(7:12,3),'+');

%写入数据------------------------------------------------------------------
result=score(:,1:3);
xlswrite('PCAresult',result);
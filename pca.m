%��ȡ����е�����-----------------------------------------------------------                               
clear;
clc;
a=xlsread('data.xlsx'); 

%������PCA�������----------------------------------------------------------
[n,m]=size(a);
temp=[];
for i=1:n
    tempmat=a(i,1:m);
	tempmat=tempmat-min(tempmat)+ones(1,m);
	temp=[temp;tempmat];
end                                                     %�������

[coeff,score,latent,tsquare]=pca(temp);            %PCA

latents=100*latent/sum(latent);                         %���㹱����

%��������ͼ-----------------------------------------------------------------
figure;
sumtemp=0;b=[];
for i=1:10
    latentstemp=latents(i,1);
    sumtemp=sumtemp+latentstemp;
    b=[b;latentstemp,sumtemp];
end
bar(b,1);hold on;
line([0,10.5],[85,85]);
legend('������','�ۼƹ�����');
xlabel('���ɷ�');ylabel('������(%)');
text(0.5,87,'85%');
suptitle('���ɷֹ�����ͼ');

figure;hold on;
scatter3(score(1:6,1),score(1:6,2),score(1:6,3),'*');
scatter3(score(7:12,1),score(7:12,2),score(7:12,3),'+');

%д������------------------------------------------------------------------
result=score(:,1:3);
xlswrite('PCAresult',result);
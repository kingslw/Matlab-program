% kMeans�ĺ��ĳ��򣬲��ϵ�������������-------------------------------------
function [ centroids ] = kMeans( dataSet, k )
    [m,n] = size(dataSet);
    %��ʼ����������
    centroids = randCent(dataSet, k);
    subCenter = zeros(m,2);%��һ��m*2�ľ��󣬵�һ�д洢��𣬵ڶ��д洢����
    change = 1;%�ж��Ƿ�ı�
    while change == 1
        change = 0;
        %��ÿһ�����ݼ������
        for i = 1:m
            minDist = inf;
            minIndex = 0;
            for j = 1:k
                 dist= distence(dataSet(i,:), centroids(j,:));
                 if dist < minDist
                     minDist = dist;
                     minIndex = j;
                 end
            end
            if subCenter(i,1) ~= minIndex
                change = 1;
                subCenter(i,:)=[minIndex, minDist];
            end        
        end
        %��k�����¾����������
        
        for j = 1:k
            sum = zeros(1,n);
            r = 0;%����
            for i = 1:m
                if subCenter(i,1) == j
                    sum = sum + dataSet(i,:);
                    r = r+1;
                end
            end
            centroids(j,:) = sum./r;
        end
    end
    
    xlswrite('result',subCenter);
    
    % �����ͼ
    figure;hold on;
    for i = 1:m
        switch subCenter(i,1)
            case 1
                plot(dataSet(i,1), dataSet(i,2), '.b');
            case 2
                plot(dataSet(i,1), dataSet(i,2), '.g');
            case 3
                plot(dataSet(i,1), dataSet(i,2), '.r');
            otherwise
                plot(dataSet(i,1), dataSet(i,2), '.c');
        end
    end
    plot(centroids(:,1),centroids(:,2),'+k');
end

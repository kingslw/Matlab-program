% kMeans的核心程序，不断迭代求解聚类中心-------------------------------------
function [ centroids ] = kMeans( dataSet, k )
    [m,n] = size(dataSet);
    %初始化聚类中心
    centroids = randCent(dataSet, k);
    subCenter = zeros(m,2);%做一个m*2的矩阵，第一列存储类别，第二列存储距离
    change = 1;%判断是否改变
    while change == 1
        change = 0;
        %对每一组数据计算距离
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
        %对k类重新就算聚类中心
        
        for j = 1:k
            sum = zeros(1,n);
            r = 0;%数量
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
    
    % 完成作图
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

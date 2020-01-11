clc;clear;
for i=1:120
    bgFile = [int2str(i),'.bmp'];
    a=imread(bgFile);
    imageorg=imresize(a,[1000,1333]);
    grayImage=rgb2gray(imageorg);
    grayImage=histeq(grayImage,256);
    grayImage=medfilt2(grayImage);
    G2C=grayslice(grayImage,128);%√‹∂»∑÷∏Ó
    h=imshow(G2C,jet(128));
    saveas(h,int2str(i),'jpg');
end

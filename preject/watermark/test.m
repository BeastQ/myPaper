% -------------------------------------------------------------------------
% 此函数的作用:用来验证各种猜想和假设
% version: v1.0
% edit time: 206-05-18
% author: WangMian
% -------------------------------------------------------------------------
clear all;close all;clc;
%单通道嵌入图像水印
I=imread('E:\MatlabProject\03-闫府家酒瓶标\PS处理\CMYK\酒杯Y通道加十字.tif');

I1=I(:,:,1);
I2=I(:,:,2);
I3=I(:,:,3);
I4=I(:,:,4);
figure;
subplot(221);imshow(I1);title('I1');
subplot(222);imshow(I2);title('I2');
subplot(223);imshow(I3);title('I3');
subplot(224);imshow(I4);title('I4');


%{
% fragment 1:用来观测图像各通道的灰度值
% 测试结果:每通道大概有20W左右灰 >= 255的,约占整幅图(33W)的20/33 = 60%。
imData = imread('Input\orgImage\RGB\1.tif');
[m,n,t] = size(imData);
th = 255;
for i = 1:t
    count = 0;
    for j = 1:m
        for k = 1:n
            if imData(j,k,i) >= th
                count = count + 1;
            end
        end
    end
    fprintf(1,'第 %d 通道系数 >= %d 的个数总共有; %d\r',i,th,count);
end
%}
%{
%--- fragement 2:用来测试在亮度域上嵌入水印信息
imDataRGB = imread('Input\orgImage\RGB\1.tif');
cform = makecform('srgb2lab');
imDataLAB = applycform(imDataRGB,cform);
imDataLAB2 = imDataLAB * 0.8;
cform = makecform('lab2srgb');
imDataRGB2 = applycform(imDataLAB2,cform);
figure(1);
subplot(2,2,1);imshow(imDataRGB);title('rgb');
subplot(2,2,2);imshow(imDataRGB2);title('rgb2');
subplot(2,2,3);imshow(imDataLAB);title('lab');
subplot(2,2,4);imshow(imDataLAB2);title('lab2');
%}
%--------------
% fragement3:直方图均衡化
%{
wmImData = imread('Output\wmImage\1.bmp');
scImData = imread('detectImage\1.bmp');
newScImData = scImData;
for i = 1:3
    temp = double(wmImData(:,:,i));
    newScImData(:,:,i) = histeq(scImData(:,:,i),hist(temp(:))); 
end
%imwrite(newScImData,'detectImage\1-c.bmp');
figure(1);
for i = 1:3
    subplot(3,3,i);
    temp = double(wmImData(:,:,i));
    hist(temp(:));
    subplot(3,3,3+i);
    temp = double(scImData(:,:,i));
    hist(temp(:));
    subplot(3,3,6+i);
    temp = double(newScImData(:,:,i));
    hist(temp(:));
end
%}
%{
hqWmImData = wmImData;
hqScImData = scImData;
hqNewScImData = newScImData;
for i = 1:3
    hqWmImData(:,:,i) = histeq(wmImData(:,:,i));
    hqScImData(:,:,i) = histeq(scImData(:,:,i));
    hqNewScImData(:,:,i) = histeq(newScImData(:,:,i));
end
figure(2);
subplot(2,3,1);imshow(wmImData);title('watermarked');
subplot(2,3,2);imshow(hqWmImData);title('watermarked-histeq');
subplot(2,3,3);imshow(scImData);title('scan');
subplot(2,3,4);imshow(hqScImData);title('watermarked-histeq');
subplot(2,3,5);imshow(newScImData);title('fx');
subplot(2,3,6);imshow(hqNewScImData);title('fx-histeq');
%}
%{
imData = imread('Input\orgImage\RGB\1.tif');
imData = rgb2lab(imData);
imData = lab2rgb(imData);
imshow(imData);
%}
%imwrite(imData,'Input\orgImage\LAB\1.jpg','quality',100);
%imData = imread('Input\orgImage\LAB\1.tif');
%imData = lab2rgb(imData);
%imshow(imData);

% Mtr = [1,2,3;4,5,6;7,8,9];
% [V1,p1] = getDiagCoeff(Mtr,1);
% V1
% V1(1:2) = [11,11];
% p1
% newMtr = revDiagCoeff(Mtr,V1,1);
% newMtr

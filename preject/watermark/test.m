% -------------------------------------------------------------------------
% �˺���������:������֤���ֲ���ͼ���
% version: v1.0
% edit time: 206-05-18
% author: WangMian
% -------------------------------------------------------------------------
clear all;close all;clc;
%��ͨ��Ƕ��ͼ��ˮӡ
I=imread('E:\MatlabProject\03-�Ƹ��Ҿ�ƿ��\PS����\CMYK\�Ʊ�Yͨ����ʮ��.tif');

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
% fragment 1:�����۲�ͼ���ͨ���ĻҶ�ֵ
% ���Խ��:ÿͨ�������20W���һ� >= 255��,Լռ����ͼ(33W)��20/33 = 60%��
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
    fprintf(1,'�� %d ͨ��ϵ�� >= %d �ĸ����ܹ���; %d\r',i,th,count);
end
%}
%{
%--- fragement 2:������������������Ƕ��ˮӡ��Ϣ
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
% fragement3:ֱ��ͼ���⻯
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

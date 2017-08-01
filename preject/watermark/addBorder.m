% -------------------------------------------------------------------------
% 此函数的作用: 给图像加黑边框(便于打印后裁剪)并保存在同一文件夹下
% version:      v1.0
% edit time:    2016-05-18
% author:       WangMian
% 传入参数:     imData:要加边框的图像 imPattern:图像的模式(CMYK,LAB,RGB,GRAY)
%               d:要加的边框的宽度(以像素为单位)
% 返回参数:     imDataBorder:已加宽度为d的边框的图像
% 说明:         此版本的matlab(2012a)对CMYK模式只支持TIF格式的图像;
%               对RGB模式和GRAY模式支持BMP,JPG,TIF格式的图像;
% -------------------------------------------------------------------------
function [imDataBorder] = addBorder(imData,imPattern,d)
% 规定要加的边框的颜色(默认为黑色)
rgbBorder = [0,0,0];%黑色的RGB值
cmykBorder = [0,0,0,255];%黑色的CMYK值
grayBorder = 0;%黑色的灰度值
% 对图像加指定颜色的边框
[m,n,t] = size(imData);
imDataBorder = uint8(zeros(m+d*2,n+d*2,t));
for i = 1:t
    if strcmp(imPattern,'CMYK')%CMYK模式
        imDataBorder(:,:,i) = cmykBorder(i);
    elseif strcmp(imPattern,'RGB')%RGB模式
        imDataBorder(:,:,i) = rgbBorder(i);
    else%GRAY模式
        imDataBorder(:,:,i) = grayBorder;
    end
    imDataBorder(d+1:m+d,d+1:n+d,i) = imData(:,:,i);
end


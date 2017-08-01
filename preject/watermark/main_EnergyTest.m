clear all;close all;clc;
%-------------------------------------------------------------------------------
%测试图像水印区域的能量
% ImgPath='detectImage\RGB\';
% xlsPath='detectImage\RGB\best.xlsx';
ImgPath='detectImage\CMYK\';
xlsPath='detectImage\CMYK\best.xlsx';
% sidelen=450;%适用于580大小的图黄蓝和红图，水印区域为450*450
% sidelen=350;%使用于490*490的红色logo图,水印区域为350*350
% sidelen=128;%使用于171*171的红logo图,水印区域为128*128
sidelen=160;%使用于210*210的红色酒杯图，水印区域为160*160
% sidelen=512;%使用于567*567的黄蓝图,水印区域为512*512

% saveWmArea(ImgPath,xlsPath,'RGB',sidelen);%保存水印区域的RGB图像到mat文件
%  saveWmArea(ImgPath,xlsPath,'CMYK',sidelen);%保存水印区域的CMYK图像转换为LAB到mat文件
%   wmAreaTest(ImgPath,'PartialMeanEnergy');%计算空域能量均值
%  wmAreaTest(ImgPath,'DCT_Signature');% 求DCT系数的正负个数及差值
%    wmAreaTest(ImgPath,'save_DCT_Relation_RGB');% 获取并保存 DCT系数关系
%  wmAreaTest(ImgPath, 'save_DCT_Relation_CMYK');% 获取并保存 DCT系数关系
%    wmAreaTest(ImgPath,'show_DCT_Relation_RGB');% 比较根据DCT系数关系，统计原图与印刷图，复印图，PS再处理图的差异度，并画图展示
 wmAreaTest(ImgPath,'show_DCT_Relation_CMYK');% 比较根据DCT系数关系，统计原图与印刷图，复印图，PS再处理图的差异度，并画图展示

% wmAreaTest(ImgPath,'PatchworkTest');% 获取并保存 DCT系数关系
fprintf(1,'运行结束');
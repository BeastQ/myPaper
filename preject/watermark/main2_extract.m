% --------------------------------------------------------------------------------------------------------------
% 此函数的作用: 滑动提取水印的主程序,适用的图像模式为RGB(水印来源于指定文件)
% 版本:         v1.1.1
% 编辑时间:     2016-06-14
% 作者:         WangMian
% 说明:         在运行此嵌入水印主程序前,请先确认或设置下面的相关参数;
%               请根据自己的实际要求修改参数或程序代码
% ------------------------------------------------------------------------------
clear all;close all;clc;

%  dtImFormat='.jpg';%图片格式
 dtImFormat='.tif';%图片格式
%  
vConType = 'ZigZag';         %矢量的构成方式:ZigZag:zigzag扫描 DiagCoeff:反对角线分组
% msgType = 'msgFromOrgImage';         
slipExtract_LAB_wavelet(vConType,dtImFormat,'CMYK',0.33);
slipExtract_LAB_wavelet(vConType,dtImFormat,'CMYK',0.7);

vConType = 'DiagCoeff'; 
slipExtract_LAB_wavelet(vConType,dtImFormat,'CMYK',0.33);
slipExtract_LAB_wavelet(vConType,dtImFormat,'CMYK',0.7);

% vConType = 'ZigZag';         %矢量的构成方式:ZigZag:zigzag扫描 DiagCoeff:反对角线分组
% msgType = 'msgFromOrgImage';         
% slipExtract(vConType,msgType,dtImFormat,'CMYK');
% 
% vConType = 'DiagCoeff'; 
% slipExtract(vConType,msgType,dtImFormat,'CMYK');
%%-------------------------------------------------------------------------------
% vConType = 'ZigZag';         %矢量的构成方式:ZigZag:zigzag扫描 DiagCoeff:反对角线分组
% 
% msgType = 'msgFromOrgImage';          %水印信息来源:allOnes:全1 allZeros:全0 alternate:01交替 random:01随机 msgFromOrgImage:来源于载体
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
%  msgType='allZeros';
%  slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='allOnes';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='alternate';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
%  
%  msgType='random';
%  slipExtract(vConType,msgType,dtImFormat,'RGB');
% %-------------------------------------------------------------------------------
% %-------------------------------------------------------------------------------
% vConType = 'DiagCoeff';         %矢量的构成方式:ZigZag:zigzag扫描 DiagCoeff:反对角线分组
% 
% msgType = 'msgFromOrgImage';          %水印信息来源:allOnes:全1 allZeros:全0 alternate:01交替 random:01随机 msgFromOrgImage:来源于载体
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='allZeros';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='allOnes';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='alternate';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='random';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% %-------------------------------------------------------------------------------
% 

% --------------------------------------------------------------------------------------------------------------
% 此函数的作用：对图像进行高斯低通滤波（空域）
% 版本：v1.0
% 最后编辑者：WangMian
% 最后编辑时间：2016-03-25 15:59
% 传入参数: 
%                ImageData: 图像数据方阵
%                n:               模板尺寸.
%                sigma:        标准差.
% 返回参数：
%                glData：     图像的低频部分的矩阵
% --------------------------------------------------------------------------------------------------------------
function [glData]=gauLowPass(cfData,n,sigma)
lowFilter=fspecial('gaussian',[n,n],sigma);
glData=imfilter(cfData,lowFilter,'replicate');

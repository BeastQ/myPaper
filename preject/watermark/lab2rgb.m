% -------------------------------------------------------------------------
% 此函数的作用:把图像从lab域转换到rgb域
% 版本: v1.0
% 编辑时间: 2016-05-21
% 作者: WangMian
% 传入参数: imDataLAB: 图像在LAB域的数据矩阵
% 返回参数: imDataRGB: 图像在RGB域的数据矩阵
% -------------------------------------------------------------------------
function [imDataRGB] = lab2rgb(imDataLAB)
% 校验输入数据是否合法
% 此处应该添加校验输入的矩阵中的每个元素是否处于lab的域范围内
% 但是考虑到实验,处理了速度，尤其是矩阵过大时，所以此处略去检测
% 在实际中应该予以添加
cform = makecform('lab2srgb');
imDataRGB = applycform(imDataLAB,cform);



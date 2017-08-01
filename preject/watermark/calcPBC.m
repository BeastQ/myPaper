% --------------------------------------------------------------------------------------------------------------
% 此函数的作用: 计算峰值信噪比psnr,误码率ber,相似系数corr,提取出的水印信息和嵌入(原始)的水印信息的不相同的数目count
% 版本:         v1.0
% 编辑时间:     2016-07-07
% 作者:         WangMian
% 最后编辑：    zcr214
% 传入参数:     wmImData: 水印图像 dtImData: 待检测的图像 bitDepth: 图像每通道的位深度
%               emMsg: 嵌入的水印数据 exMsg: 提取出的水印数据 msgLen: 水印数据的长度
% 返回参数:     psnr: 峰值信噪比 ber:误码率 corr: 相似系数 count:提取出的水印信息和嵌入(原始)的水印信息的不相同的数目
% --------------------------------------------------------------------------------------------------------------              
function [psnr,ber,corr,count] = calcPBC(wmImData,dtImData,bitdepth,emMsg,exMsg)
psnr = getPsnr(wmImData,dtImData,bitdepth);
ber = getBer(emMsg, exMsg);
corr = getCorr(emMsg, exMsg);
count =getDiffcount(emMsg,exMsg);


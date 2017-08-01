% --------------------------------------------------------------------------------------------------------------
% 此函数的作用：计算水印信息的误码率
% 版本：v1.0
% 最后编辑者：WangMian
% 最后编辑时间：2016-03-25 16:04
% 传入参数：
%               originalMsg: 原始水印信息
%               extractMsg:  提取到的水印信息
% 返回参数：
%               ber：           误码率
% --------------------------------------------------------------------------------------------------------------function [ber]=getBer(originalMsg,extractMsg)
function [ber] = getBer(originalMsg,extractMsg)
originalMsg=double(originalMsg(:));
extractMsg=double(extractMsg(:));
len=min(length(originalMsg),length(extractMsg));
ber=sum(abs(originalMsg(1:len)-extractMsg(1:len)))/len;


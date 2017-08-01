% --------------------------------------------------------------------------------------------------------------
% 此函数的作用：计算水印信息的相似系数（相关系数）
% 版本：v1.1
% 最后编辑者：WangMian
% 最后编辑时间：2016-05-23
% 传入参数：
%               originalMsg：原始水印信息
%               extractMsg： 提取的水印信息
% 返回参数：
%               corr：            水印信息的相似系数
% 说明：    此程序使用皮尔逊相关系数公式来计算水印信息的相似系数.
% --------------------------------------------------------------------------------------------------------------
function [corr]=getCorr(originalMsg,extractMsg)
len=min(length(originalMsg(:)),length(extractMsg(:)));
x=double(originalMsg(1:len));
y=double(extractMsg(1:len));
% mx=mean(x);
% my=mean(y);
q = sqrt(sum(x.^2))*sqrt(sum(y.^2));
% if q ~= 0
%     corr=sum((x-mx).*(y-my))/q;
 if q ~= 0
    corr=sum(x.*y)/q;
else
    if sum(x.^2) == 0 || sum(y.^2) == 0
        x = double(~x);
        y = double(~y);
    end
    corr=sum(x.*y)/(sqrt(sum(x.^2))*sqrt(sum(y.^2))); 
end
corr=abs(corr);

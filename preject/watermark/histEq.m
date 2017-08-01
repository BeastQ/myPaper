% -------------------------------------------------------------------------
% 此函数的作用:对图像作直返图均衡
% 版本: v1.0
% 编辑时间: 2015-05-21
% 作者: WangMian
% 传入参数: scImData: 扫描图数据矩阵 wmImData:水印图数据矩阵 
% -------------------------------------------------------------------------
function [newScImData] = histEq(scImData,wmImData)
newScImData = scImData;
[~,~,t] = size(scImData);
for i = 1:t
    temp = double(wmImData(:,:,i));
    newScImData(:,:,i) = histeq(scImData(:,:,i),hist(temp(:))); 
end

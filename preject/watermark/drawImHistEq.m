% -------------------------------------------------------------------------
% 此函数的作用:显示水印图、扫描图和对扫描图均衡化后的图像的直方图
% 版本: v1.0
% 编辑时间: 2015-05-21
% 作者: WangMian
% 传入参数: wmImData:水印图数据矩阵 scImData: 扫描图数据矩阵
% -------------------------------------------------------------------------
function drawImHistEq(wmImData,scImData)
newScImData = scImData;
for i = 1:3
    temp = double(wmImData(:,:,i));
    newScImData(:,:,i) = histeq(scImData(:,:,i),hist(temp(:))); 
end
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
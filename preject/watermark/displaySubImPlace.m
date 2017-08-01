% -------------------------------------------------------------------------
% 此函数的作用:根据给定的坐标参数,显示某一个子块在原图中的位置
% version: v1.0
% edit time: 2016-05-19
% author: WangMian
% 传入参数: orgImData:原图 rowStart,rowEnd:子块在原图中的行起始和结束坐标
%           colStart,colEnd:子块在原图中的列起始和结束坐标
% -------------------------------------------------------------------------
function displaySubImPlace(orgImData,rowStart,rowEnd,colStart,colEnd)
orgImDataNew = orgImData;
[m,n,~] = size(orgImData);
%校验给定的坐标是否合法
if (rowStart>=1)&&(rowStart<rowEnd)&&(rowEnd<=m)&&(colStart>=1)&&(colStart<colEnd)...
        &&(colEnd<=n)
        orgImDataNew(rowStart:rowEnd,colStart:colEnd,:) = 0;
        figure(1000);
        subplot(1,2,1);imshow(orgImData);title('原图');
        subplot(1,2,2);imshow(orgImDataNew);title('子块在原图的位置(以黑色表示)');
else
    fprintf(1,'错误:给定的坐标不合法!\r');
end

    
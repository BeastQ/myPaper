% -------------------------------------------------------------------------
% �˺���������:���ݸ������������,��ʾĳһ���ӿ���ԭͼ�е�λ��
% version: v1.0
% edit time: 2016-05-19
% author: WangMian
% �������: orgImData:ԭͼ rowStart,rowEnd:�ӿ���ԭͼ�е�����ʼ�ͽ�������
%           colStart,colEnd:�ӿ���ԭͼ�е�����ʼ�ͽ�������
% -------------------------------------------------------------------------
function displaySubImPlace(orgImData,rowStart,rowEnd,colStart,colEnd)
orgImDataNew = orgImData;
[m,n,~] = size(orgImData);
%У������������Ƿ�Ϸ�
if (rowStart>=1)&&(rowStart<rowEnd)&&(rowEnd<=m)&&(colStart>=1)&&(colStart<colEnd)...
        &&(colEnd<=n)
        orgImDataNew(rowStart:rowEnd,colStart:colEnd,:) = 0;
        figure(1000);
        subplot(1,2,1);imshow(orgImData);title('ԭͼ');
        subplot(1,2,2);imshow(orgImDataNew);title('�ӿ���ԭͼ��λ��(�Ժ�ɫ��ʾ)');
else
    fprintf(1,'����:���������겻�Ϸ�!\r');
end

    
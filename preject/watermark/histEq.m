% -------------------------------------------------------------------------
% �˺���������:��ͼ����ֱ��ͼ����
% �汾: v1.0
% �༭ʱ��: 2015-05-21
% ����: WangMian
% �������: scImData: ɨ��ͼ���ݾ��� wmImData:ˮӡͼ���ݾ��� 
% -------------------------------------------------------------------------
function [newScImData] = histEq(scImData,wmImData)
newScImData = scImData;
[~,~,t] = size(scImData);
for i = 1:t
    temp = double(wmImData(:,:,i));
    newScImData(:,:,i) = histeq(scImData(:,:,i),hist(temp(:))); 
end

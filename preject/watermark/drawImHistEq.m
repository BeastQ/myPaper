% -------------------------------------------------------------------------
% �˺���������:��ʾˮӡͼ��ɨ��ͼ�Ͷ�ɨ��ͼ���⻯���ͼ���ֱ��ͼ
% �汾: v1.0
% �༭ʱ��: 2015-05-21
% ����: WangMian
% �������: wmImData:ˮӡͼ���ݾ��� scImData: ɨ��ͼ���ݾ���
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
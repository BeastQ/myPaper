% --------------------------------------------------------------------------------------------------------------
% �˺��������ã�����ˮӡ��Ϣ��������
% �汾��v1.0
% ���༭�ߣ�WangMian
% ���༭ʱ�䣺2016-03-25 16:04
% ���������
%               originalMsg: ԭʼˮӡ��Ϣ
%               extractMsg:  ��ȡ����ˮӡ��Ϣ
% ���ز�����
%               ber��           ������
% --------------------------------------------------------------------------------------------------------------function [ber]=getBer(originalMsg,extractMsg)
function [ber] = getBer(originalMsg,extractMsg)
originalMsg=double(originalMsg(:));
extractMsg=double(extractMsg(:));
len=min(length(originalMsg),length(extractMsg));
ber=sum(abs(originalMsg(1:len)-extractMsg(1:len)))/len;


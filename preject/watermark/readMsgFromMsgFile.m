% -------------------------------------------------------------------------
% �˺���������:��ָ���ı���ˮӡ��Ϣ���ļ��ж�ȡˮӡ
% �汾:v1.0
% �༭ʱ��:2016-05-24
% ����:WangMian
% �������:msgPath:����ˮӡ�ļ����ļ�·�� msgName:ˮӡ�ļ�������
%          msgLen:��Ҫ��ˮӡ�ļ��ж�ȡ��ˮӡ�ĳ���
% ���ز���:msg:��ˮӡ�ļ��ж�ȡ�ĳ���ΪmsgLen��ˮӡ
% -------------------------------------------------------------------------
function [msg] = readMsgFromMsgFile(msgPath,msgName,msgLen)
fprintf(1,'���ˮӡ�ļ� %s �Ƿ����...\r',strcat(msgPath,msgName));
if ~exist(strcat(msgPath,msgName)) %#ok<EXIST>
   fprintf(1,'ˮӡ�ļ������ڻ������ˮӡ�ļ�·������,������ֹ!\r');
   return ;
else
    fprintf(1,'ˮӡ�ļ� %s ���ڣ���ʼ��ȡˮӡ��Ϣ...\r',strcat(msgPath,msgName));
    msg = load(strcat(msgPath,msgName));
    if numel(msg) < msgLen
        fprintf(1,'�����е�ˮӡ�ļ� %s �ж�ȡ��ˮӡ��Ϣ�ĳ���С�ڸ����ĳ���!������ֹ!\r',strcat(msgPath,msgName));
        return ;
    else
        msg = reshape(msg,1,numel(msg));
        msg = msg(1:msgLen);
    end
end
fprintf(1,'ˮӡ���ݶ�ȡ���...\r');

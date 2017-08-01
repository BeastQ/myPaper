% --------------------------------------------------------------------------------------------------------------
% �˺��������ã�����ˮӡ��Ϣ������ϵ�������ϵ����
% �汾��v1.1
% ���༭�ߣ�WangMian
% ���༭ʱ�䣺2016-05-23
% ���������
%               originalMsg��ԭʼˮӡ��Ϣ
%               extractMsg�� ��ȡ��ˮӡ��Ϣ
% ���ز�����
%               corr��            ˮӡ��Ϣ������ϵ��
% ˵����    �˳���ʹ��Ƥ��ѷ���ϵ����ʽ������ˮӡ��Ϣ������ϵ��.
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

function SetofSig=get_DCT_Siganture(stg,sidelen,positionR,positionC)
% function [zheng,fu]=DCT_Siganture(stg,sidelen,positionR,positionC)
% stg Ŀ��ͼ��
% sidelen �ֿ��С�߳�
% positionR �ֿ��е�λ���б�
% positionC �ֿ��е�λ���б�
% ����ֵ��ÿ���ֿ�ָ��λ�õ�����ϵ���ļ���

sdct=blkproc(stg,[sidelen sidelen],'dct2'); %�ֿ���dct�任
[m,n]=size(sdct);
numR=floor(m/sidelen);
numC=floor(n/sidelen);
SetofSig=zeros(numR,numC);
for r=1:numR
    for c=1:numC
        SetofSig(r,c)=sdct(positionR+sidelen*(r-1),positionC+sidelen*(c-1));      
    end
end
% -------------------------------------------------------------------------
% �˺���������: ��ԭʼͼ��(����ͼ��)��ֱ����ȡˮӡ
% �汾: v1.0
% ����: WangMian
% ���༭:zcr214
% �༭ʱ��: 2016-06-28
% ˵��: ֱ�Ӵ�������ȡ��ˮӡ�ļ����������Ϊ ͼ����_��ȡʱ�� ���ļ�����;
%       ÿ��ͨ����ȡ��ˮӡ,����������Ϊ msg_ͼ����_ͨ�����_��ȡʱ��.txt �ļ���;
%       ��������ȡˮӡʱ���㷨������ͼ��λ�ñ�������Readme.txt�ļ���
% -------------------------------------------------------------------------
% ----���ò���-------------------------------------------------------------
clear all;close all;clc;
vConType ='DiagCoeff';% 'Zigzag'; %%             %ʸ�����ɷ�ʽZigzag����DiagCoeff
imNum = 1;                          %����ͼ������
msgPath = strcat('Input\msg\msgFromOrgImageBy',vConType,'\');%����ֱ�Ӵ�����ͼ����ȡ����ˮӡ���ļ���·��
msgLen = 128;                       %����ˮӡ��Ϣ�ĳ���
% orgImPath = 'Input\orgImage\RGB\';  %ԭʼͼ��(����ͼ��)���ļ���·��
orgImPath = 'Input\orgImage\CMYK\';  %ԭʼͼ��(����ͼ��)���ļ���·��
orgImFormat = '.tif';               %����ͼ��ĸ�ʽ
vlen = 32;p = 2.0;delta = 0.33;LorH='H';%����Ƕ��1bitˮӡ��ÿ���������ĳ��ȣ�lp-norm�Ľף�������������ȡ��λ�õ�Ƶ���Ǹ�Ƶ
rowStart = 66;rowEnd = 515;
colStart = 66;colEnd = 515;
% ----��ȡˮӡ--------------------------------------------------------------
if ~exist(msgPath) %#ok<EXIST> 
    mkdir(msgPath);% ����Ƿ���ڱ���ˮӡ���ݵ��ļ���
end
for i = 1 : imNum
    if ~exist(msgPath) %#ok<EXIST>
        mkdir(msgPath);
    end
    %��ȡ����ͼ�������Ϣ
    orgImData = imread(strcat(orgImPath,num2str(i),orgImFormat));
    [m,n,t] = size(orgImData);
    %����ֱ�Ӵ�����ͼ����ȡˮӡ��Ϣ��������õĲ���
    fid1 = fopen(strcat(msgPath,'Readme.txt'),'w');
    fprintf(fid1,'---------------------------------------------------\r\n');
    fprintf(fid1,'�㷨����:vlen:%d p:%.2f delta:%.2f msgLen:%d\r\n',vlen,p,delta,msgLen);
    fprintf(fid1,'��ȡˮӡ������ͼ��λ��:%s\r\n',strcat(orgImPath,num2str(i),orgImFormat));
    fprintf(fid1,'��ͼ��Ϣ: ��ԭͼ�е�λ��:rowStart:%d rowEnd:%d colStart:%d colEnd:%d,��СΪ:%d * %d\r\n',...
    rowStart,rowEnd,colStart,colEnd,(rowEnd-rowStart+1),(colEnd-colStart+1));
    fprintf(fid1,'ͼ�����Ϣ:��С:%d * %d,ͨ����:%d\r\n',m,n,t);
    fprintf(fid1,'---------------------------------------------------\r\n');
    fclose(fid1);
    %У���ȡ������ͼ���Ƿ��Ƿ���
    if m ~= n
        fprintf(1,'��ȡ����,����ͼ���Ƿ���,������ֹ!\r');
        return ;
    end
    %ÿ��ͨ������ȡ,�������ڲ�ͬ���ļ���
    for j = 1 : t
        if strcmp(vConType,'ZigZag') == 1
            msg = giQimDehide_DCT_Glp(orgImData(rowStart:rowEnd,colStart:colEnd,j),delta,vlen,p,msgLen,LorH);
        else
            msg = giQimDehide_DCT_Glp2(orgImData(rowStart:rowEnd,colStart:colEnd,j),delta,vlen,p,msgLen,LorH);
        end
        fid2 = fopen(strcat(msgPath,'msg_',num2str(j),'.txt'),'w');
        for k = 1 : msgLen%���浽�ļ�
            fprintf(fid2,'%d\r\n',msg(k));
        end
        fclose(fid2);
    end
end


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
vConType =   'ZigZag';%% 'DiagCoeff';%%           %ʸ�����ɷ�ʽZigzag����DiagCoeff
vlen = 32;p = 2.0;delta = 0.7;%����Ƕ��1bitˮӡ��ÿ���������ĳ��ȣ�lp-norm�Ľף�������������ȡ��λ�õ�Ƶ���Ǹ�Ƶ
imNum = 1;                          %����ͼ������
msgPath = strcat('Input\msg\msgFromOrgImageBy',vConType,'\');%����ֱ�Ӵ�����ͼ����ȡ����ˮӡ���ļ���·��
msgLen = 128;                       %����ˮӡ��Ϣ�ĳ���
% orgImPath = 'Input\orgImage\RGB\';  %ԭʼͼ��(����ͼ��)���ļ���·��
orgImPath = 'Input\orgImage\CMYK\';  %ԭʼͼ��(����ͼ��)���ļ���·��
orgImFormat = '.tif';               %����ͼ��ĸ�ʽ
% rowStart = 66;rowEnd = 515;%������580��С��ͼ�����ͺ�ͼ��ˮӡ����Ϊ450*450
% colStart = 66;colEnd = 515;
rowStart = 26;rowEnd = 185;%ʹ����210*210�ĺ�ɫ�Ʊ�ͼ��ˮӡ����Ϊ160*160
colStart = 26;colEnd = 185;
% rowStart = 71;rowEnd = 420;%ʹ����490*490�ĺ�ɫlogoͼ,ˮӡ����Ϊ350*350
% colStart = 71;colEnd = 420;
% rowStart = 26;rowEnd = 537;%ʹ����567*567�Ļ���ͼ,ˮӡ����Ϊ512*512
% colStart = 26;colEnd = 537;
% rowStart = 24;rowEnd = 151;%ʹ����171*171�ĺ�logoͼ,ˮӡ����Ϊ128*128
% colStart = 24;colEnd = 151;
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
     
    % CMYK --> Lab
    cform1 = makecform('cmyk2srgb'); % cmykתsrgb
    rgb = applycform(orgImData,cform1);
    cform2 = makecform('srgb2lab'); % srgbתlab
    orgImData = applycform(rgb,cform2); 
    
    [m,n,t] = size(orgImData);
    %��С���任
    [wA,wH,wV,wD]=dwt2(orgImData(rowStart:rowEnd,colStart:colEnd,1),'haar');
%     wA=round(wA);
    wH=round(wH);
    wV=round(wV);
    wD=round(wD); 
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
    %����ͨ����С���任3����Ƶ�Ӵ���ȡ,���������ļ���
    if strcmp(vConType,'ZigZag')==1
     msg = giQimDehide_DCT_Glp(wH, delta, vlen, p, msgLen);
     fid2 = fopen(strcat(msgPath,'msg_wH_delta',num2str(delta),'.txt'),'w');
     fprintf(fid2,'%d\r\n',msg);
     fclose(fid2);
     
     msg = giQimDehide_DCT_Glp(wV, delta, vlen, p, msgLen);
     fid2 = fopen(strcat(msgPath,'msg_wV_delta',num2str(delta),'.txt'),'w');
     fprintf(fid2,'%d\r\n',msg);
     fclose(fid2);
     
     msg = giQimDehide_DCT_Glp(wD, delta, vlen, p, msgLen);
     fid2 = fopen(strcat(msgPath,'msg_wD_delta',num2str(delta),'.txt'),'w');
     fprintf(fid2,'%d\r\n',msg);
     fclose(fid2);
    elseif strcmp(vConType,'DiagCoeff')==1
     msg = giQimDehide_DCT_Glp2(wH, delta, vlen, p, msgLen);
     fid2 = fopen(strcat(msgPath,'msg_wH_delta',num2str(delta),'.txt'),'w');
     fprintf(fid2,'%d\r\n',msg);
     fclose(fid2);
     
     msg = giQimDehide_DCT_Glp2(wV, delta, vlen, p, msgLen);
     fid2 = fopen(strcat(msgPath,'msg_wV_delta',num2str(delta),'.txt'),'w');
     fprintf(fid2,'%d\r\n',msg);
     fclose(fid2);
     
     msg = giQimDehide_DCT_Glp2(wD, delta, vlen, p, msgLen);
     fid2 = fopen(strcat(msgPath,'msg_wD_delta',num2str(delta),'.txt'),'w');
     fprintf(fid2,'%d\r\n',msg);
     fclose(fid2);
    else
        fprintf(1,'��ȷ��vConType��������дZigzag����DiagCoeff');
        return;
    end
   
    
end
fprintf(1,'ˮӡ������ϣ�\n');

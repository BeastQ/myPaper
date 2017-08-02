% --------------------------------------------------------------------------------------------------------------
% �˺���������: ��ȡˮӡ��������,���õ�ͼ��ģʽΪRGB(ˮӡ��Դ��ָ���ļ�)(û�л�������)
% �汾:         v1.2
% �༭ʱ��:     2016-05-27
% ����:         WangMian
% ˵��:         �����д�Ƕ��ˮӡ������ǰ,����ȷ�ϻ������������ز���;
%               ������Լ���ʵ��Ҫ���޸Ĳ�����������
% --------------------------------------------------------------------------------------------------------------
clear all;close all;clc;
vConType = 'ZigZag';         %ʸ���Ĺ��ɷ�ʽ:ZigZag:zigzagɨ�� DiagCoeff:���Խ��߷���
msgType = 'msgFromOrgImage';    %ˮӡ��Ϣ��Դ:allOnes:ȫ1 allZeros:ȫ0
                                %alternate:01���� random:01��� msgFromOrgImage:��Դ������
%----������ز���-----------------------------------------------------------
if strcmp(msgType,'msgFromOrgImage') == 1%����ˮӡ��Ϣ���ļ������ļ��е�·��
    msgPath = strcat('Input/msg/',msgType,'By',vConType,'/'); 
else
    msgPath = strcat('Input/msg/',msgType,'/');
end
msgLen= 128;                       %�������ȡ��ˮӡ��Ϣ�ĳ���
imNum = 1;                         %ͼ�������
wmImPath = strcat('Output/wmImage/RGB/',vConType,'/',msgType,'/');%�����ˮӡͼ�񱣴���ļ���·��
wmImFormat = '.tif';               %�����ˮӡͼ��ĸ�ʽ(��Ϊjpg��ʽ����˳���Ĭ�ϱ����ͼ������Ϊ100����ѹ������
                                   %��Ϊtif��ʽ���򱣴��ͼ�������ֱ���Ϊ300���Ҳ�ѹ��;��Ϊ������ʽ����Ĭ�ϵĲ�������)
dtImPath = strcat('detectImage/RGB/',vConType,'/',msgType,'/');   %������ͼ����ļ���·��
dtImFormat = '.jpg';                   %������ͼ��ĸ�ʽ
bitdepth = 8;vlen = 32;p = 2.0;delta = 0.33;%ͼ���ÿͨ����λ��ȣ�����Ƕ��1bitˮӡ��ÿ���������ĳ��ȣ�lp-norm�Ľף���������
rowStart = 66;rowEnd = 515;
colStart = 66;colEnd = 515;
%-----����ˮӡ��ȡ----------------------------------------------------------
fid = fopen(strcat(dtImPath,'exInfo.txt'),'w');
fprintf(fid,'---------------------------------------------------------------------------------------------\r\n');
fprintf(fid,'�����ͼ��ģʽ:%s �����ͼ���ʽ:%s ͼ������:%d ˮӡ����: %d\r\n','RGB',dtImFormat,imNum,msgLen);
fprintf(fid,'�㷨����: BitDepth: %.2f  vlen: %.2f  p: %.2f  delta: %.2f\r\n',3*bitdepth,vlen,p,delta);
fprintf(fid,'��ͼ��Ϣ: ��ԭͼ�е�λ��:rowStart:%d rowEnd:%d colStart:%d colEnd:%d,��СΪ:%d * %d\r\n',...
    rowStart,rowEnd,colStart,colEnd,(rowEnd-rowStart+1),(colEnd-colStart+1));
fprintf(fid,'---------------------------------------------------------------------------------------------\r\n');
for imName = 1:imNum
    %��ȡ����ͼ��ˮӡͼ������
    wmImData = imread(strcat(wmImPath,num2str(imName),wmImFormat)); 
    [m,n,t] = size(wmImData);
    if m ~= n %���ˮӡͼ���Ƿ��Ƿ���ͼ��
        fprintf(1,'ˮӡͼ�Ĵ�СΪ%d*%d,���Ƿ���ͼ��,������ֹ!\r',m,n);
    end
    %��ȡ�����(����ӡ���ӡȻ��ӡ��ɨ����еõ�)��ͼ������
    dtImData = imread(strcat(dtImPath,num2str(imName),dtImFormat));
    fprintf(fid,'��%d��ͼ�������Ϣ�����ܲ���:\r\n',imName);
    psnrSum = 0.0;berSum =0.0;corrSum = 0.0;countSum = 0.0;
    if strcmp(msgType,'msgFromOrgImage') ~= 1%��Ƕ���ˮӡ��Ϣ����Դ������
        fprintf(1,'׼����ȡˮӡ��Ϣ...\r');
        emMsg = readMsgFromMsgFile(msgPath,'msg.txt',msgLen);
    end
    for i = 1:t%����ͨ������ȡ
        if strcmp(msgType,'msgFromOrgImage') == 1%Ƕ���ˮӡ��Ϣ��Դ������ͼ��
            fprintf(1,'׼����ȡ %d ͨ����ˮӡ��Ϣ...\r',i);
            emMsg = readMsgFromMsgFile(msgPath,strcat('msg_',num2str(i),'.txt'),msgLen);
        end
        fprintf(1,'��ʼ��ȡ�� %d ͨ����ˮӡ��Ϣ...\r',i);
        sub_dtImData = dtImData(rowStart:rowEnd,colStart:colEnd,i);
        sub_wmImData = wmImData(rowStart:rowEnd,colStart:colEnd,i);
        if strcmp(vConType,'ZigZag') == 1
            exMsg = giQimDehide_DCT_Glp(sub_dtImData,delta,vlen,p,msgLen);
        else
            exMsg = giQimDehide_DCT_Glp2(sub_dtImData,delta,vlen,p,msgLen);
        end
        [psnr,ber,corr,count] = calcPBC(sub_wmImData,sub_dtImData,bitdepth,emMsg,exMsg,msgLen);%����PSNR,BER,CORR��COUNT
        fprintf(fid,'�� %d ͨ����psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\r\n',i,psnr,ber,corr,count);%д���ļ�
        psnrSum = psnrSum + psnr;berSum = berSum + ber;corrSum = corrSum + corr;countSum = countSum + count;
    end
    fprintf(fid,'ƽ����Ϣ ��psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\r\n',psnrSum/t,berSum/t,corrSum/t,floor(countSum/t));
    fprintf(fid,'---------------------------------------------------------------------------------------------\r\n');
end
if fid ~= 1
    fclose(fid);
end
fprintf(1,'ˮӡ��ȡ���!\r');

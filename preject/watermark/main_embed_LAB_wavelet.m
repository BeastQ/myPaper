% --------------------------------------------------------------------------------------------------------------
% �˺���������: �����ȿռ�Ƕ��ˮӡ��������,���õ�ͼ��ģʽΪCMYK(ˮӡ��Դ��ָ���ļ�)
% �汾:         v1.0
% �༭ʱ��:     2016-06-30
% ����:         zcr214
% ˵��:         �����д�Ƕ��ˮӡ������ǰ,����ȷ�ϻ������������ز���;
%               ������Լ���ʵ��Ҫ���޸Ĳ�����������
% --------------------------------------------------------------------------------------------------------------
clear all;close all;clc;
%--------������ز���--------------------------------------------------------------------------------------------
vConType = 'ZigZag';  %  % 'ZigZag';      %ʸ���Ĺ��ɷ�ʽ:ZigZag:zigzagɨ�� DiagCoeff:���Խ��߷���

colorSpace='RGB';%'RGB'; %ɫ�ʿռ�

msgOriPath = strcat('Input/msg/msgFromOrgImageBy',vConType,'/'); 
msgRandPath= strcat('Input/msg/Random/'); 

% orgImPath = 'Input\orgImage\RGB\'; %ԭʼͼ�������ļ��е�·��
orgImPath = ['Input/orgImage/',colorSpace,'/']; %ԭʼͼ�������ļ��е�·��
orgImFormat = '.tiff';              %ԭʼͼ��ĸ�ʽ
% wmImPath = strcat('Output\wmImage\RGB\',vConType,'\',msgType,'\');%�����ˮӡͼ�񱣴���ļ���·��
msgLen= 128;                       %�������ȡ��ˮӡ��Ϣ�ĳ���
imgfiles=dir([orgImPath,'*',orgImFormat]);
imNum = length(imgfiles);                         %ͼ�������
                                   
bitdepth = 8;vlen = 32;p = 2.0;delta = 0.33;%ͼ���ÿͨ����λ��ȣ�����Ƕ��1bitˮӡ��ÿ���������ĳ��ȣ�lp-norm�Ľף���������
sf = 0.99;                          %���ڸ�ͼ��ÿͨ�������60%��ֵ��Ϊ255��,���Զ�ͼ��ÿͨ����ֵ��������
% rowStart = 66;rowEnd = 515;%������580��С��ͼ�����ͺ�ͼ��ˮӡ����Ϊ450*450
% colStart = 66;colEnd = 515;
% rowStart = 26;rowEnd = 185;%ʹ����210*210�ĺ�ɫ�Ʊ�ͼ��ˮӡ����Ϊ160*160
% colStart = 26;colEnd = 185;
%rowStart = 71;rowEnd = 420;%ʹ����490*490�ĺ�ɫlogoͼ,ˮӡ����Ϊ350*350
%colStart = 71;colEnd = 420;
rowStart = 56;rowEnd = 455;%ʹ����512*512��lenaͼ,ˮӡ����Ϊ400*400
colStart = 56;colEnd = 455;
% rowStart = 26;rowEnd = 537;%ʹ����567*567�Ļ���ͼ,ˮӡ����Ϊ512*512
% colStart = 26;colEnd = 537;
% rowStart = 24;rowEnd = 151;%ʹ����171*171�ĺ�logoͼ,ˮӡ����Ϊ128*128
% colStart = 24;colEnd = 151;

wmImPath = ['Output/wmImage/',colorSpace,'/',vConType,'/delta',num2str(delta),'/'];%�����ˮӡͼ�񱣴���ļ���·��
wmImFormat = '.tiff';               %�����ˮӡͼ��ĸ�ʽ(��Ϊjpg��ʽ����˳���Ĭ�ϱ����ͼ������Ϊ100����ѹ������
                                   %��Ϊtif��ʽ���򱣴��ͼ�������ֱ���Ϊ300���Ҳ�ѹ��;��Ϊ������ʽ����Ĭ�ϵĲ�������)

%------����ˮӡǶ��--------------------------------------
for imName = 1:imNum
    orgImData = imread([orgImPath,imgfiles(imName).name]);%��ȡԭʼͼ������
     % CMYK --> Lab
    %cform1 = makecform('cmyk2srgb'); % cmykתsrgb
    %rgb = applycform(orgImData,cform1);
    %cform2 = makecform('srgb2lab'); % srgbתlab
    %orgImData = applycform(rgb,cform2); 
    
    % RGB --> Lab
    cform1 = makecform('srgb2lab'); % srgbתlab
    orgImData = applycform(orgImData,cform1);
    
%     orgImData = orgImData * sf;%��ԭʼͼ�����ɫֵ��������,��������Ϊsf
    [m,n,t] = size(orgImData);  
   
    if m ~= n %���ԭʼͼ���Ƿ��Ƿ���ͼ��
        fprintf(1,'ѡ���ԭʼ(����)ͼ���СΪ:%d*%d,���Ƿ���ͼ��,������ֹ!\r',m,n);
        return ;
    end
    %Ƕ��ˮӡ
    emMsgRand= readMsgFromMsgFile(msgRandPath,strcat('msg.txt'),msgLen);
    emMsgwH = readMsgFromMsgFile(msgOriPath,strcat('msg_wH_delta',num2str(delta),'.txt'),msgLen);
    emMsgwV = readMsgFromMsgFile(msgOriPath,strcat('msg_wV_delta',num2str(delta),'.txt'),msgLen);
    emMsgwD = readMsgFromMsgFile(msgOriPath,strcat('msg_wD_delta',num2str(delta),'.txt'),msgLen);
   
    wmImData = orgImData;
    SubOrgImData=orgImData(rowStart:rowEnd,colStart:colEnd,1);
     %��С���任,�õ�Ƕ��ˮӡ��Ŀ������
    [wA,wH,wV,wD]=dwt2(SubOrgImData,'haar');
    wA=round(wA);
    wH=round(wH);
    wV=round(wV);
    wD=round(wD);
      
        if strcmp(vConType,'ZigZag')==1%ʸ�����ɷ�ʽΪzigzag
            wA = giQimHide_DCT_Glp(wA,emMsgRand,delta,vlen,p,1);
            wH = giQimHide_DCT_Glp(wH,emMsgwH,delta,vlen,p,1);
            wV = giQimHide_DCT_Glp(wV,emMsgwV,delta,vlen,p,1);
            wD = giQimHide_DCT_Glp(wD,emMsgwD,delta,vlen,p,1);

            xx = idwt2(wA,wH,wV,wD,'haar');
            wmImData(rowStart:rowEnd,colStart:colEnd,1)=xx;
        
        elseif strcmp(vConType,'DiagCoeff')==1%ʸ�����ɷ�ʽΪ�Խ��߷���
            wA = giQimHide_DCT_Glp2(wA,emMsgRand,delta,vlen,p,1);
            wH = giQimHide_DCT_Glp2(wH,emMsgwH,delta,vlen,p,1);
            wV = giQimHide_DCT_Glp2(wV,emMsgwV,delta,vlen,p,1);
            wD = giQimHide_DCT_Glp2(wD,emMsgwD,delta,vlen,p,1);
            xx = idwt2(wA,wH,wV,wD,'haar');
            wmImData(rowStart:rowEnd,colStart:colEnd,1)=xx;
        else
            fprintf(1,'��ȷ��vConType��������дZigzag����DiagCoeff');
            return;
       end
    
%------����ˮӡͼ��---------------------------------------------------------
% Lab --> RGB/CMYK
cform3 = makecform('lab2srgb');
stg = applycform(wmImData,cform3); 
%cform4 = makecform('srgb2cmyk');
%wmImData = applycform(stg,cform4);

    stg = uint8(stg);
%     wmImDataBorder = addBorder(wmImData,'RGB',5);
    wmImDataBorder = addBorder(stg,colorSpace,5);
    wmImDataBorderSize2 = imresize(wmImDataBorder,2,'bicubic');
    if ~exist(wmImPath) %#ok<EXIST>
        mkdir(wmImPath);
    end
    if strcmp(wmImFormat,'.jpg') == 1
        imwrite(stg,[wmImPath,'delta',num2str(delta),'_',imgfiles(imName).name,wmImFormat],'quality',100);
        imwrite(wmImDataBorder,[wmImPath,'delta',num2str(delta),imgfiles(imName).name,'_Border_',wmImFormat],'quality',100);%������к�ɫ�߿��ͼ��(���ڴ�ӡɨ���ü�)
        imwrite(wmImDataBorderSize2,[wmImPath,'delta',num2str(delta),imgfiles(imName).name,'_BorderSize2_',wmImFormat],'quality',100);%������к�ɫ�߿��ͼ��(���ڴ�ӡɨ���ü�)
    elseif strcmp(wmImFormat,'.tiff') == 1
        imwrite(stg,[wmImPath,'delta',num2str(delta),'_',imgfiles(imName).name],'Resolution',300,'Compression','none');
        imwrite(wmImDataBorder,[wmImPath,'delta',num2str(delta),'_Border_',imgfiles(imName).name],'Resolution',300,'Compression','lzw');
        imwrite(wmImDataBorderSize2,[wmImPath,'delta',num2str(delta),'_Border2_',imgfiles(imName).name],'Resolution',300,'Compression','lzw');
    else
        imwrite(stg,[wmImPath,'delta',num2str(delta),'_',imgfiles(imName).name]);
        imwrite(wmImDataBorder,[wmImPath,'delta',num2str(delta),'_Border_',imgfiles(imName).name]);
        imwrite(wmImDataBorderSize2,[wmImPath,'delta',num2str(delta),'_Border2_',imgfiles(imName).name]);
    end
end
fprintf(1,'ˮӡǶ���ͼ�񱣴����!\r\r');


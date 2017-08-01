%main_attackTest
% --------��ȡˮӡ------------
vConType =  'ZigZag';  %% 'DiagCoeff'; %%    %ʸ���Ĺ��ɷ�ʽ:ZigZag:zigzagɨ�� DiagCoeff:���Խ��߷���
colorSpace='CMYK';%'RGB'; %ɫ�ʿռ�
bitdepth = 8;vlen = 32;p = 2.0;delta = 0.7;%ͼ���ÿͨ����λ��ȣ�����Ƕ��1bitˮӡ��ÿ���������ĳ��ȣ�lp-norm�Ľף���������
sf = 0.99;                          %���ڸ�ͼ��ÿͨ�������60%��ֵ��Ϊ255��,���Զ�ͼ��ÿͨ����ֵ��������
% rowStart = 66;rowEnd = 515;%������580��С��ͼ�����ͺ�ͼ��ˮӡ����Ϊ450*450
% colStart = 66;colEnd = 515;
% rowStart = 26;rowEnd = 185;%ʹ����210*210�ĺ�ɫ�Ʊ�ͼ��ˮӡ����Ϊ160*160
% colStart = 26;colEnd = 185;
% rowStart = 71;rowEnd = 420;%ʹ����490*490�ĺ�ɫlogoͼ,ˮӡ����Ϊ350*350
% colStart = 71;colEnd = 420;
% rowStart = 26;rowEnd = 537;%ʹ����567*567�Ļ���ͼ,ˮӡ����Ϊ512*512
% colStart = 26;colEnd = 537;
rowStart = 24;rowEnd = 151;%ʹ����171*171�ĺ�logoͼ,ˮӡ����Ϊ128*128
colStart = 24;colEnd = 151;
wmImPath = ['Output\wmImage\',colorSpace,'\',vConType,'\delta',num2str(delta),'\'];%�����ˮӡͼ�񱣴���ļ���·��
wmImFormat = '.tif';
imgfiles=dir([wmImPath,'*',wmImFormat]);
num=length(imgfiles);
method = {'no_attack','noise-wiener','dither','stable-scal_0.8','scal','noise-gaussian_10','noise-gaussian_20'};
% �������� 
Len = length(method);  
msgLen=128;
msgRandPath= strcat('Input\msg\Random\'); 
emMsgwA= readMsgFromMsgFile(msgRandPath,strcat('msg.txt'),msgLen);
msgOriPath = strcat('Input\msg\msgFromOrgImageBy',vConType,'\'); 
emMsgwH = readMsgFromMsgFile(msgOriPath,strcat('msg_wH_delta',num2str(delta),'.txt'),msgLen);
emMsgwV = readMsgFromMsgFile(msgOriPath,strcat('msg_wV_delta',num2str(delta),'.txt'),msgLen);
emMsgwD = readMsgFromMsgFile(msgOriPath,strcat('msg_wD_delta',num2str(delta),'.txt'),msgLen);
emMsgwH = emMsgwH';
emMsgwV = emMsgwV';
emMsgwD = emMsgwD';
for n=1:num
    stg0 = imread([wmImPath,imgfiles(n).name]);
    % CMYK --> Lab
        cform1 = makecform('cmyk2srgb'); % cmykתsrgb
        rgb = applycform(stg0,cform1);
        cform2 = makecform('srgb2lab'); % srgbתlab
        stg0 = applycform(rgb,cform2); 
    fid=fopen([wmImPath,imgfiles(n).name,'.txt'],'w');
    for i = 1:1%Len
       
        stg = stg0(rowStart:rowEnd,colStart:colEnd,:);   
       
        stgAttackLab = attack2(stg, method{i});
        
        %�õ�ˮӡ����dwt�Ӵ�
        stg1 = stgAttackLab(:,:,1);
        [wA,wH,wV,wD]=dwt2(stg1,'haar');
        wA=round(wA);
        wH=round(wH);
        wV=round(wV);
        wD=round(wD);
        
        if strcmp(vConType,'DiagCoeff')==1
            exMsgwA = giQimDehide_DCT_Glp2(wA,delta,vlen,p,msgLen);
            exMsgwH = giQimDehide_DCT_Glp2(wH,delta,vlen,p,msgLen);
            exMsgwV = giQimDehide_DCT_Glp2(wV,delta,vlen,p,msgLen);
            exMsgwD = giQimDehide_DCT_Glp2(wD,delta,vlen,p,msgLen);
%             exMsgH =exMsgH';
        else
            exMsgwA = giQimDehide_DCT_Glp(wA,delta,vlen,p,msgLen);
     fid2 = fopen('Output\wmImage\CMYK\ZigZag\delta0.7\whitemsg.txt','w');
     fprintf(fid2,'%d\r\n',exMsgwA);
     fclose(fid2);
            exMsgwH = giQimDehide_DCT_Glp(wH,delta,vlen,p,msgLen);
            exMsgwV = giQimDehide_DCT_Glp(wV,delta,vlen,p,msgLen);
            exMsgwD = giQimDehide_DCT_Glp(wD,delta,vlen,p,msgLen);
%              exMsgH =exMsgH';
        end
        % -------����PSNR,BER��CORR-------------------------------------------
       berwA = getBer(emMsgwA, exMsgwA);
       corrwA = getCorr(emMsgwA, exMsgwA);
       berwH = getBer(emMsgwH, exMsgwH);
       corrwH = getCorr(emMsgwH, exMsgwH);
       berwV = getBer(emMsgwV, exMsgwV);
       corrwV = getCorr(emMsgwV, exMsgwV);
       berwD = getBer(emMsgwD, exMsgwD);
       corrwD = getCorr(emMsgwD, exMsgwD);
       
       
        fprintf(fid,'%s������:\n',method{i});
        fprintf(fid,'wA,berwA: %.2f corrwA: %.2f\n',berwA,corrwA);
        fprintf(fid,'wH,berwH: %.2f corrwH: %.2f\n',berwH,corrwH);
        fprintf(fid,'wV,berwV: %.2f corrwV: %.2f\n',berwV,corrwV);
        fprintf(fid,'wD,berwD: %.2f corrwD: %.2f\n',berwD,corrwD);
        fprintf(fid,'\n');
    end
    fclose(fid);
end
fprintf(1,'ˮӡ�������!�����Զ��˳���\n');
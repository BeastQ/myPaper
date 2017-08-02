% --------------------------------------------------------------------------------------------------------------
% �˺���������: ������ȡˮӡ�ĺ�������,���õ�ͼ��ģʽΪRGB(ˮӡ��Դ��ָ���ļ�)
% �汾:         v1.1.1
% �༭ʱ��:     2016-06-14
% ����:         WangMian
% ���༭��    zcr214
% ������        vConType,ʸ�����ɷ�ʽ
%               msgType,ˮӡ��Ϣ����
%               dtImFormat,�ļ���ʽ
%               colorSpace����ɫ�ռ�RGB��CMYK
% ˵��:         �����д�Ƕ��ˮӡ������ǰ,����ȷ�ϻ������������ز���;
%               ������Լ���ʵ��Ҫ���޸Ĳ�����������
% --------------------------------------------------------------------------------------------------------------
function slipExtract_LAB_wavelet(vConType,dtImFormat,colorSpace,delta)
%----������ز���-----------------------------------------------------------
msgLen= 128;        %�������ȡ��ˮӡ��Ϣ�ĳ���                                
bitdepth = 8;vlen = 32;p = 2.0;%delta = 0.33; %LorH='H';                       %ͼ���ÿͨ����λ��ȣ�����Ƕ��1bitˮӡ��ÿ���������ĳ��ȣ�lp-norm�Ľף���������
hSlidePix = 5;              %ˮƽ���������ط�Χ
vSlidePix = 5;              %��ֱ���������ط�Χ
% rowStart = 66;rowEnd = 515;%������580��С��ͼ�����ͺ�ͼ��ˮӡ����Ϊ450*450
% colStart = 66;colEnd = 515;
%rowStart = 26;rowEnd = 185;%ʹ����210*210�ĺ�ɫ�Ʊ�ͼ��ˮӡ����Ϊ160*160
%colStart = 26;colEnd = 185;

rowStart = 56;rowEnd = 455;%ʹ����512*512��lenaͼ,ˮӡ����Ϊ400*400
colStart = 56;colEnd = 455;
% rowStart = 71;rowEnd = 420;%ʹ����490*490�ĺ�ɫlogoͼ,ˮӡ����Ϊ350*350
% colStart = 71;colEnd = 420;
% rowStart = 26;rowEnd = 537;%ʹ����567*567�Ļ���ͼ,ˮӡ����Ϊ512*512
% colStart = 26;colEnd = 537;
% rowStart = 24;rowEnd = 151;%ʹ����171*171�ĺ�logoͼ,ˮӡ����Ϊ128*128
% colStart = 24;colEnd = 151;

dtImPath = ['detectImage/',colorSpace,'/',vConType,'/delta',num2str(delta),'/']; %������ͼ����ļ���·��

files=dir([dtImPath,'*',dtImFormat]);
imNum = length(files);   %ͼ������

%-----����ˮӡ��ȡ----------------------------------------------------------
%��ȡԭʼˮӡ��Ϣ
msgRandPath= strcat('Input/msg/Random/'); 
emMsgwA= readMsgFromMsgFile(msgRandPath,strcat('msg.txt'),msgLen);
msgOriPath = strcat('Input/msg/msgFromOrgImageBy',vConType,'/'); 
emMsgwH = readMsgFromMsgFile(msgOriPath,strcat('msg_wH_delta',num2str(delta),'.txt'),msgLen);
emMsgwV = readMsgFromMsgFile(msgOriPath,strcat('msg_wV_delta',num2str(delta),'.txt'),msgLen);
emMsgwD = readMsgFromMsgFile(msgOriPath,strcat('msg_wD_delta',num2str(delta),'.txt'),msgLen);
emMsgwH = emMsgwH';
emMsgwV = emMsgwV';
emMsgwD = emMsgwD';

for n = 1:imNum
    
    fid = fopen([dtImPath,files(n).name,'_exInfo.txt'],'w');
    fprintf(fid,'---------------------------------------------------------------------------------------------\n');
    fprintf(fid,'�����ͼ��ģʽ:%s �����ͼ���ʽ:%s ˮӡ����: %d\n',colorSpace,dtImFormat,msgLen);
    fprintf(fid,'�㷨����: BitDepth: %.2f  vlen: %.2f  p: %.2f  delta: %.2f\n',3*bitdepth,vlen,p,delta);
    fprintf(fid,'��ͼ��Ϣ: ��ԭͼ�е�λ��:rowStart:%d rowEnd:%d colStart:%d colEnd:%d,��СΪ:%d * %d\n',...
        rowStart,rowEnd,colStart,colEnd,(rowEnd-rowStart+1),(colEnd-colStart+1));
    fprintf(fid,'---------------------------------------------------------------------------------------------\n');
   
    fprintf(1,'---------------------------------------------------------------------------------------------\n');
    fprintf(1,'�����ͼ��ģʽ:%s �����ͼ���ʽ:%s ˮӡ����: %d\n',colorSpace,dtImFormat,msgLen);
    fprintf(1,'�㷨����: BitDepth: %.2f  vlen: %.2f  p: %.2f  delta: %.2f\n',3*bitdepth,vlen,p,delta);
    fprintf(1,'��ͼ��Ϣ: ��ԭͼ�е�λ��:rowStart:%d rowEnd:%d colStart:%d colEnd:%d,��СΪ:%d * %d\n',...
        rowStart,rowEnd,colStart,colEnd,(rowEnd-rowStart+1),(colEnd-colStart+1));
    fprintf(1,['��ʼ���',files(n).name,'\n----------------------------------------------------------------------------------------\n']);
   
    %��ȡ�����(����ӡ���ӡȻ��ӡ��ɨ����еõ�)��ͼ������
    dtImData = imread([dtImPath,files(n).name]);
    
     % CMYK --> Lab
    %cform1 = makecform('cmyk2srgb'); % cmykתsrgb
    %rgb = applycform(dtImData,cform1);
    %cform2 = makecform('srgb2lab'); % srgbתlab
    %dtImData = applycform(rgb,cform2); 
    
    % RGB --> Lab
    dtImData = rgb2lab(dtImData);
   
    %������ȡ�����ͼ���Ƕ��ˮӡ������,������ˮӡ��ȡ
     

    maxCorrL = 0.0;
    for i = -hSlidePix : hSlidePix
        for j = -vSlidePix : vSlidePix
            fprintf(fid,'������ȡλ��Ϊrow=%03d��col=%03d��ͼ�������Ϣ�����ܲ���:\n',rowStart+i,colStart+j);
                       
                sub_dtImData = dtImData(rowStart+i:rowEnd+i,colStart+j:colEnd+j,1);
                
                [wA,wH,wV,wD]=dwt2(sub_dtImData,'haar');
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
                    exMsgwH = giQimDehide_DCT_Glp(wH,delta,vlen,p,msgLen);
                    exMsgwV = giQimDehide_DCT_Glp(wV,delta,vlen,p,msgLen);
                    exMsgwD = giQimDehide_DCT_Glp(wD,delta,vlen,p,msgLen);
        %              exMsgH =exMsgH';
                end
               [psnrwH,berwH,corrwH,countwH]=calcPBC(sub_dtImData,sub_dtImData,bitdepth,emMsgwH,exMsgwH);%����PSNR,BER,CORR��COUNT
               [psnrwV,berwV,corrwV,countwV]=calcPBC(sub_dtImData,sub_dtImData,bitdepth,emMsgwV,exMsgwV);%����PSNR,BER,CORR��COUNT
               [psnrwD,berwD,corrwD,countwD]=calcPBC(sub_dtImData,sub_dtImData,bitdepth,emMsgwD,exMsgwD);%����PSNR,BER,CORR��COUNT
                psnrH=(psnrwH+psnrwV+psnrwD)/3;
                berH=(berwH+berwV+berwD)/3;
                corrH=(corrwH+corrwV+corrwD)/3;
                countH =(countwH+countwV+countwD)/3; 
                
                fprintf(fid,'��Ƶ��psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',psnrH,berH,corrH,countH);%д���ļ�
                [psnrL,berL,corrL,countL] = calcPBC(sub_dtImData,sub_dtImData,bitdepth,emMsgwA,exMsgwA);%����PSNR,BER,CORR��COUNT
                fprintf(fid,'��Ƶ��psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',psnrL,berL,corrL,countL);%д���ļ�
                
            
          fprintf(fid,'---------------------------------------------------------------------------------------------\n');
            if maxCorrL <= corrL
                maxCorrL = corrL;
              
                bestResult.row=rowStart+i;
                bestResult.col=colStart+j;
                bestResult.psnrL=psnrL;
                bestResult.berL=berL;
                bestResult.corrL=corrL;
                bestResult.numOfNotSameL=countL;
                
                bestResult.psnrH=psnrH;
                bestResult.berH=berH;
                bestResult.corrH=corrH;
                bestResult.numOfNotSameH=countH;
            end
         
        end
    end
    fprintf(fid,'---------------------------------------------------------------\n');
    fprintf(fid,'��õ�Ϊ��ͼ����λ��row= %d,col=%d\n\n',bestResult.row,bestResult.col);
   
    fprintf(1,'��õ�Ϊ��ͼ����λ��row= %d,col=%d\n\n',bestResult.row,bestResult.col);
%д��������õĵ��ļ�
  
    fprintf(fid,'���ͼ��ĵ�Ƶ������Ϣ ��psnrL: %.2f berL: %.2f corrL: %.2f numOfNotSameL: %d\n',bestResult.psnrL,bestResult.berL,bestResult.corrL,bestResult.numOfNotSameL);
    fprintf(fid,'���ͼ��ĸ�Ƶ������Ϣ ��psnrH: %.2f berH: %.2f corrH: %.2f numOfNotSameH: %d\n',bestResult.psnrH,bestResult.berH,bestResult.corrH,bestResult.numOfNotSameH);
%     if fid ~= 1
        fclose(fid);
%     end
    fprintf(1,[files(n).name,' ������\n']);
    fprintf(1,'-----------------------------------------------------------------\n');
end





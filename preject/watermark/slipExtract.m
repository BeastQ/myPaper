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
function slipExtract(vConType,msgType,dtImFormat,colorSpace)
hSlidePix = 5;              %ˮƽ���������ط�Χ
vSlidePix = 5;              %��ֱ���������ط�Χ
%----������ز���-----------------------------------------------------------
if strcmp(msgType,'msgFromOrgImage') == 1                           %����ˮӡ��Ϣ���ļ������ļ��е�·��
    msgPath = strcat('Input\msg\',msgType,'By',vConType,'\'); 
else
    msgPath = strcat('Input\msg\',msgType,'\');
end
msgLen= 128;                                                        %�������ȡ��ˮӡ��Ϣ�ĳ���
% colorSpace='RGB';%'CMYK';
wmImPath = ['Output\wmImage\',colorSpace,'\',vConType,'\',msgType,'\'];  %�����ˮӡͼ�񱣴���ļ���·��
wmImFormat = '.tif';                                                %�����ˮӡͼ��ĸ�ʽ
dtImPath = ['detectImage\',colorSpace,'\',vConType,'\',msgType,'\']; %������ͼ����ļ���·��

files=dir([dtImPath,'*',dtImFormat]);
imNum = length(files);                                                          %ͼ�������
% dtImFormat = '.jpg';                                                %������ͼ��ĸ�ʽ
bitdepth = 8;vlen = 32;p = 2.0;delta = 0.33; LorH='H';                       %ͼ���ÿͨ����λ��ȣ�����Ƕ��1bitˮӡ��ÿ���������ĳ��ȣ�lp-norm�Ľף���������
rowStart = 66;rowEnd = 515;                                         %Ƕ��ˮӡ��������ԭͼ�еĺ�������ʼ����������
colStart = 66;colEnd = 515;                                         %Ƕ��ˮӡ��������ԭͼ�е���������ʼ����������
%-----����ˮӡ��ȡ----------------------------------------------------------

    %��ȡ����ͼ��ˮӡͼ������
    wmImData = imread(strcat(wmImPath,'1',wmImFormat));  
    [m,n,t] = size(wmImData);
    if m ~= n %���ˮӡͼ���Ƿ��Ƿ���ͼ��(
        
        fprintf(1,'ԭˮӡͼ�Ĵ�СΪ%d*%d,���Ƿ���ͼ��,������ֹ!\r',m,n);
    end
     %��ȡԭʼˮӡ��Ϣ
    fprintf(1,'׼����ȡˮӡ��Ϣ...\r');
    if strcmp(msgType,'msgFromOrgImage') ~= 1%��Ƕ���ˮӡ��Ϣ����Դ������
        emMsg = readMsgFromMsgFile(msgPath,'msg.txt',msgLen);
    else
        emMsg2 = rand(1,msgLen,t);
        for i = 1 : t
            emMsg2(:,:,i) = readMsgFromMsgFile(msgPath,strcat('msg_',num2str(i),'.txt'),msgLen);
        end
    end   
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

    %������ȡ�����ͼ���Ƕ��ˮӡ������,������ˮӡ��ȡ
  %  slideImNum = 1;
    maxCorr = 0.0;
    bestResult.Num = 1;
    for i = -hSlidePix : hSlidePix
        for j = -vSlidePix : vSlidePix
            fprintf(fid,'������ȡλ��Ϊrow=%03d��col=%03d��ͼ�������Ϣ�����ܲ���:\n',rowStart+i,colStart+j);
            
            psnrSum = 0.0;berSum =0.0;corrSum = 0.0;countSum = 0.0;
             for k = 1:t%����ͨ������ȡ
           % for k = 2:3%����ͨ������ȡ
                sub_wmImData = wmImData(rowStart:rowEnd,colStart:colEnd,k);
                sub_dtImData = dtImData(rowStart+i:rowEnd+i,colStart+j:colEnd+j,k);
                if strcmp(vConType,'ZigZag') == 1
                    exMsg = giQimDehide_DCT_Glp(sub_dtImData,delta,vlen,p,msgLen,LorH);
                else
                    exMsg = giQimDehide_DCT_Glp2(sub_dtImData,delta,vlen,p,msgLen,LorH);
                end
                if strcmp(msgType,'msgFromOrgImage') == 1%Ƕ���ˮӡ��Ϣ��Դ������
                    [psnr,ber,corr,count] = calcPBC(sub_wmImData,sub_dtImData,bitdepth,emMsg2(:,:,k),exMsg,msgLen);%����PSNR,BER,CORR��COUNT
                else
                    [psnr,ber,corr,count] = calcPBC(sub_wmImData,sub_dtImData,bitdepth,emMsg,exMsg,msgLen);%����PSNR,BER,CORR��COUNT
                end
                fprintf(fid,'�� %d ͨ����psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',k,psnr,ber,corr,count);%д���ļ�
%                 fprintf(1,'�� %d ͨ����psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\r',k,psnr,ber,corr,count);%�������Ļ
                psnrSum = psnrSum + psnr;berSum = berSum + ber;corrSum = corrSum + corr;countSum = countSum + count;
            end
            fprintf(fid,'ƽ����Ϣ ��psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',psnrSum/t,berSum/t,corrSum/t,floor(countSum/t));
%             fprintf(1,'ƽ����Ϣ ��psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\r',psnrSum/t,berSum/t,corrSum/t,floor(countSum/t));
            fprintf(fid,'---------------------------------------------------------------------------------------------\n');
            if maxCorr <= corrSum/t
                maxCorr = corrSum/t;
               % bestResult.Num = slideImNum;
                bestResult.row=rowStart+i;
                bestResult.col=colStart+j;
                bestResult.psnr=psnrSum/t;
                bestResult.ber=berSum/t;
                bestResult.corr=corrSum/t;
                bestResult.numOfNotSame=floor(countSum/t);
            end
           % slideImNum = slideImNum + 1;
        end
    end
    fprintf(fid,'---------------------------------------------------------------\n');
    fprintf(fid,'��õ�Ϊ��ͼ����λ��row= %d,col=%d\n\n',bestResult.row,bestResult.col);
   
    fprintf(1,'��õ�Ϊ��ͼ����λ��row= %d,col=%d\n\n',bestResult.row,bestResult.col);
%д��������õĵ��ļ�
  
    fprintf(fid,'���ͼ�������ƽ����Ϣ ��psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',bestResult.psnr,bestResult.ber,bestResult.corr,bestResult.numOfNotSame);
    fprintf(1,'���ͼ�������ƽ����Ϣ ��psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',bestResult.psnr,bestResult.ber,bestResult.corr,bestResult.numOfNotSame);
    if fid ~= 1
        fclose(fid);
    end
    fprintf(1,[files(n).name,' ������\n']);
    fprintf(1,'-----------------------------------------------------------------\n');
end





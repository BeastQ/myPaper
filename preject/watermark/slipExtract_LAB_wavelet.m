% --------------------------------------------------------------------------------------------------------------
% 此函数的作用: 滑动提取水印的函数程序,适用的图像模式为RGB(水印来源于指定文件)
% 版本:         v1.1.1
% 编辑时间:     2016-06-14
% 作者:         WangMian
% 最后编辑：    zcr214
% 参数：        vConType,矢量构成方式
%               msgType,水印信息类型
%               dtImFormat,文件格式
%               colorSpace，颜色空间RGB或CMYK
% 说明:         在运行此嵌入水印主程序前,请先确认或设置下面的相关参数;
%               请根据自己的实际要求修改参数或程序代码
% --------------------------------------------------------------------------------------------------------------
function slipExtract_LAB_wavelet(vConType,dtImFormat,colorSpace,delta)
%----设置相关参数-----------------------------------------------------------
msgLen= 128;        %设置需读取的水印信息的长度                                
bitdepth = 8;vlen = 32;p = 2.0;%delta = 0.33; %LorH='H';                       %图像的每通道的位深度，用作嵌入1bit水印的每个子向量的长度，lp-norm的阶，量化步长
hSlidePix = 5;              %水平滑动的像素范围
vSlidePix = 5;              %垂直滑动的像素范围
% rowStart = 66;rowEnd = 515;%适用于580大小的图黄蓝和红图，水印区域为450*450
% colStart = 66;colEnd = 515;
%rowStart = 26;rowEnd = 185;%使用于210*210的红色酒杯图，水印区域为160*160
%colStart = 26;colEnd = 185;

rowStart = 56;rowEnd = 455;%使用于512*512的lena图,水印区域为400*400
colStart = 56;colEnd = 455;
% rowStart = 71;rowEnd = 420;%使用于490*490的红色logo图,水印区域为350*350
% colStart = 71;colEnd = 420;
% rowStart = 26;rowEnd = 537;%使用于567*567的黄蓝图,水印区域为512*512
% colStart = 26;colEnd = 537;
% rowStart = 24;rowEnd = 151;%使用于171*171的红logo图,水印区域为128*128
% colStart = 24;colEnd = 151;

dtImPath = ['detectImage/',colorSpace,'/',vConType,'/delta',num2str(delta),'/']; %待检测的图像的文件夹路径

files=dir([dtImPath,'*',dtImFormat]);
imNum = length(files);   %图像数量

%-----进行水印提取----------------------------------------------------------
%读取原始水印信息
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
    fprintf(fid,'待检测图像模式:%s 待检测图像格式:%s 水印长度: %d\n',colorSpace,dtImFormat,msgLen);
    fprintf(fid,'算法参数: BitDepth: %.2f  vlen: %.2f  p: %.2f  delta: %.2f\n',3*bitdepth,vlen,p,delta);
    fprintf(fid,'子图信息: 在原图中的位置:rowStart:%d rowEnd:%d colStart:%d colEnd:%d,大小为:%d * %d\n',...
        rowStart,rowEnd,colStart,colEnd,(rowEnd-rowStart+1),(colEnd-colStart+1));
    fprintf(fid,'---------------------------------------------------------------------------------------------\n');
   
    fprintf(1,'---------------------------------------------------------------------------------------------\n');
    fprintf(1,'待检测图像模式:%s 待检测图像格式:%s 水印长度: %d\n',colorSpace,dtImFormat,msgLen);
    fprintf(1,'算法参数: BitDepth: %.2f  vlen: %.2f  p: %.2f  delta: %.2f\n',3*bitdepth,vlen,p,delta);
    fprintf(1,'子图信息: 在原图中的位置:rowStart:%d rowEnd:%d colStart:%d colEnd:%d,大小为:%d * %d\n',...
        rowStart,rowEnd,colStart,colEnd,(rowEnd-rowStart+1),(colEnd-colStart+1));
    fprintf(1,['开始检测',files(n).name,'\n----------------------------------------------------------------------------------------\n']);
   
    %读取待检测(仅打印或打印然后复印后扫描剪切得到)的图像数据
    dtImData = imread([dtImPath,files(n).name]);
    
     % CMYK --> Lab
    %cform1 = makecform('cmyk2srgb'); % cmyk转srgb
    %rgb = applycform(dtImData,cform1);
    %cform2 = makecform('srgb2lab'); % srgb转lab
    %dtImData = applycform(rgb,cform2); 
    
    % RGB --> Lab
    dtImData = rgb2lab(dtImData);
   
    %滑动获取待检测图像的嵌入水印的区域,并进行水印提取
     

    maxCorrL = 0.0;
    for i = -hSlidePix : hSlidePix
        for j = -vSlidePix : vSlidePix
            fprintf(fid,'滑动提取位置为row=%03d，col=%03d的图的相关信息及性能参数:\n',rowStart+i,colStart+j);
                       
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
               [psnrwH,berwH,corrwH,countwH]=calcPBC(sub_dtImData,sub_dtImData,bitdepth,emMsgwH,exMsgwH);%计算PSNR,BER,CORR和COUNT
               [psnrwV,berwV,corrwV,countwV]=calcPBC(sub_dtImData,sub_dtImData,bitdepth,emMsgwV,exMsgwV);%计算PSNR,BER,CORR和COUNT
               [psnrwD,berwD,corrwD,countwD]=calcPBC(sub_dtImData,sub_dtImData,bitdepth,emMsgwD,exMsgwD);%计算PSNR,BER,CORR和COUNT
                psnrH=(psnrwH+psnrwV+psnrwD)/3;
                berH=(berwH+berwV+berwD)/3;
                corrH=(corrwH+corrwV+corrwD)/3;
                countH =(countwH+countwV+countwD)/3; 
                
                fprintf(fid,'高频：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',psnrH,berH,corrH,countH);%写入文件
                [psnrL,berL,corrL,countL] = calcPBC(sub_dtImData,sub_dtImData,bitdepth,emMsgwA,exMsgwA);%计算PSNR,BER,CORR和COUNT
                fprintf(fid,'低频：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',psnrL,berL,corrL,countL);%写入文件
                
            
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
    fprintf(fid,'最好的为子图区域位于row= %d,col=%d\n\n',bestResult.row,bestResult.col);
   
    fprintf(1,'最好的为子图区域位于row= %d,col=%d\n\n',bestResult.row,bestResult.col);
%写出性能最好的到文件
  
    fprintf(fid,'最好图像的低频数据信息 ：psnrL: %.2f berL: %.2f corrL: %.2f numOfNotSameL: %d\n',bestResult.psnrL,bestResult.berL,bestResult.corrL,bestResult.numOfNotSameL);
    fprintf(fid,'最好图像的高频数据信息 ：psnrH: %.2f berH: %.2f corrH: %.2f numOfNotSameH: %d\n',bestResult.psnrH,bestResult.berH,bestResult.corrH,bestResult.numOfNotSameH);
%     if fid ~= 1
        fclose(fid);
%     end
    fprintf(1,[files(n).name,' 检测完毕\n']);
    fprintf(1,'-----------------------------------------------------------------\n');
end





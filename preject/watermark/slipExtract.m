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
function slipExtract(vConType,msgType,dtImFormat,colorSpace)
hSlidePix = 5;              %水平滑动的像素范围
vSlidePix = 5;              %垂直滑动的像素范围
%----设置相关参数-----------------------------------------------------------
if strcmp(msgType,'msgFromOrgImage') == 1                           %保存水印信息的文件所在文件夹的路径
    msgPath = strcat('Input\msg\',msgType,'By',vConType,'\'); 
else
    msgPath = strcat('Input\msg\',msgType,'\');
end
msgLen= 128;                                                        %设置需读取的水印信息的长度
% colorSpace='RGB';%'CMYK';
wmImPath = ['Output\wmImage\',colorSpace,'\',vConType,'\',msgType,'\'];  %输出的水印图像保存的文件夹路径
wmImFormat = '.tif';                                                %输出的水印图像的格式
dtImPath = ['detectImage\',colorSpace,'\',vConType,'\',msgType,'\']; %待检测的图像的文件夹路径

files=dir([dtImPath,'*',dtImFormat]);
imNum = length(files);                                                          %图像的数量
% dtImFormat = '.jpg';                                                %待检测的图像的格式
bitdepth = 8;vlen = 32;p = 2.0;delta = 0.33; LorH='H';                       %图像的每通道的位深度，用作嵌入1bit水印的每个子向量的长度，lp-norm的阶，量化步长
rowStart = 66;rowEnd = 515;                                         %嵌入水印的区域在原图中的横坐标起始、结束坐标
colStart = 66;colEnd = 515;                                         %嵌入水印的区域在原图中的纵坐标起始、结束坐标
%-----进行水印提取----------------------------------------------------------

    %读取载密图像（水印图像）数据
    wmImData = imread(strcat(wmImPath,'1',wmImFormat));  
    [m,n,t] = size(wmImData);
    if m ~= n %检测水印图像是否是方形图像(
        
        fprintf(1,'原水印图的大小为%d*%d,不是方形图像,程序中止!\r',m,n);
    end
     %读取原始水印信息
    fprintf(1,'准备读取水印信息...\r');
    if strcmp(msgType,'msgFromOrgImage') ~= 1%欲嵌入的水印信息非来源于载体
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

    %滑动获取待检测图像的嵌入水印的区域,并进行水印提取
  %  slideImNum = 1;
    maxCorr = 0.0;
    bestResult.Num = 1;
    for i = -hSlidePix : hSlidePix
        for j = -vSlidePix : vSlidePix
            fprintf(fid,'滑动提取位置为row=%03d，col=%03d的图的相关信息及性能参数:\n',rowStart+i,colStart+j);
            
            psnrSum = 0.0;berSum =0.0;corrSum = 0.0;countSum = 0.0;
             for k = 1:t%各个通道都提取
           % for k = 2:3%各个通道都提取
                sub_wmImData = wmImData(rowStart:rowEnd,colStart:colEnd,k);
                sub_dtImData = dtImData(rowStart+i:rowEnd+i,colStart+j:colEnd+j,k);
                if strcmp(vConType,'ZigZag') == 1
                    exMsg = giQimDehide_DCT_Glp(sub_dtImData,delta,vlen,p,msgLen,LorH);
                else
                    exMsg = giQimDehide_DCT_Glp2(sub_dtImData,delta,vlen,p,msgLen,LorH);
                end
                if strcmp(msgType,'msgFromOrgImage') == 1%嵌入的水印信息来源于载体
                    [psnr,ber,corr,count] = calcPBC(sub_wmImData,sub_dtImData,bitdepth,emMsg2(:,:,k),exMsg,msgLen);%计算PSNR,BER,CORR和COUNT
                else
                    [psnr,ber,corr,count] = calcPBC(sub_wmImData,sub_dtImData,bitdepth,emMsg,exMsg,msgLen);%计算PSNR,BER,CORR和COUNT
                end
                fprintf(fid,'第 %d 通道：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',k,psnr,ber,corr,count);%写入文件
%                 fprintf(1,'第 %d 通道：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\r',k,psnr,ber,corr,count);%输出到屏幕
                psnrSum = psnrSum + psnr;berSum = berSum + ber;corrSum = corrSum + corr;countSum = countSum + count;
            end
            fprintf(fid,'平均信息 ：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',psnrSum/t,berSum/t,corrSum/t,floor(countSum/t));
%             fprintf(1,'平均信息 ：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\r',psnrSum/t,berSum/t,corrSum/t,floor(countSum/t));
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
    fprintf(fid,'最好的为子图区域位于row= %d,col=%d\n\n',bestResult.row,bestResult.col);
   
    fprintf(1,'最好的为子图区域位于row= %d,col=%d\n\n',bestResult.row,bestResult.col);
%写出性能最好的到文件
  
    fprintf(fid,'最好图像的数据平均信息 ：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',bestResult.psnr,bestResult.ber,bestResult.corr,bestResult.numOfNotSame);
    fprintf(1,'最好图像的数据平均信息 ：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\n',bestResult.psnr,bestResult.ber,bestResult.corr,bestResult.numOfNotSame);
    if fid ~= 1
        fclose(fid);
    end
    fprintf(1,[files(n).name,' 检测完毕\n']);
    fprintf(1,'-----------------------------------------------------------------\n');
end





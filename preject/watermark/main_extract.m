% --------------------------------------------------------------------------------------------------------------
% 此函数的作用: 提取水印的主程序,适用的图像模式为RGB(水印来源于指定文件)(没有滑动矫正)
% 版本:         v1.2
% 编辑时间:     2016-05-27
% 作者:         WangMian
% 说明:         在运行此嵌入水印主程序前,请先确认或设置下面的相关参数;
%               请根据自己的实际要求修改参数或程序代码
% --------------------------------------------------------------------------------------------------------------
clear all;close all;clc;
vConType = 'ZigZag';         %矢量的构成方式:ZigZag:zigzag扫描 DiagCoeff:反对角线分组
msgType = 'msgFromOrgImage';    %水印信息来源:allOnes:全1 allZeros:全0
                                %alternate:01交替 random:01随机 msgFromOrgImage:来源于载体
%----设置相关参数-----------------------------------------------------------
if strcmp(msgType,'msgFromOrgImage') == 1%保存水印信息的文件所在文件夹的路径
    msgPath = strcat('Input/msg/',msgType,'By',vConType,'/'); 
else
    msgPath = strcat('Input/msg/',msgType,'/');
end
msgLen= 128;                       %设置需读取的水印信息的长度
imNum = 1;                         %图像的数量
wmImPath = strcat('Output/wmImage/RGB/',vConType,'/',msgType,'/');%输出的水印图像保存的文件夹路径
wmImFormat = '.tif';               %输出的水印图像的格式(若为jpg格式，则此程序默认保存的图像质量为100（不压缩）；
                                   %若为tif格式，则保存的图像质量分辨率为300并且不压缩;若为其它格式，则按默认的参数保存)
dtImPath = strcat('detectImage/RGB/',vConType,'/',msgType,'/');   %待检测的图像的文件夹路径
dtImFormat = '.jpg';                   %待检测的图像的格式
bitdepth = 8;vlen = 32;p = 2.0;delta = 0.33;%图像的每通道的位深度，用作嵌入1bit水印的每个子向量的长度，lp-norm的阶，量化步长
rowStart = 66;rowEnd = 515;
colStart = 66;colEnd = 515;
%-----进行水印提取----------------------------------------------------------
fid = fopen(strcat(dtImPath,'exInfo.txt'),'w');
fprintf(fid,'---------------------------------------------------------------------------------------------\r\n');
fprintf(fid,'待检测图像模式:%s 待检测图像格式:%s 图像数量:%d 水印长度: %d\r\n','RGB',dtImFormat,imNum,msgLen);
fprintf(fid,'算法参数: BitDepth: %.2f  vlen: %.2f  p: %.2f  delta: %.2f\r\n',3*bitdepth,vlen,p,delta);
fprintf(fid,'子图信息: 在原图中的位置:rowStart:%d rowEnd:%d colStart:%d colEnd:%d,大小为:%d * %d\r\n',...
    rowStart,rowEnd,colStart,colEnd,(rowEnd-rowStart+1),(colEnd-colStart+1));
fprintf(fid,'---------------------------------------------------------------------------------------------\r\n');
for imName = 1:imNum
    %读取载密图像（水印图像）数据
    wmImData = imread(strcat(wmImPath,num2str(imName),wmImFormat)); 
    [m,n,t] = size(wmImData);
    if m ~= n %检测水印图像是否是方形图像
        fprintf(1,'水印图的大小为%d*%d,不是方形图像,程序中止!\r',m,n);
    end
    %读取待检测(仅打印或打印然后复印后扫描剪切得到)的图像数据
    dtImData = imread(strcat(dtImPath,num2str(imName),dtImFormat));
    fprintf(fid,'第%d幅图的相关信息及性能参数:\r\n',imName);
    psnrSum = 0.0;berSum =0.0;corrSum = 0.0;countSum = 0.0;
    if strcmp(msgType,'msgFromOrgImage') ~= 1%欲嵌入的水印信息非来源于载体
        fprintf(1,'准备读取水印信息...\r');
        emMsg = readMsgFromMsgFile(msgPath,'msg.txt',msgLen);
    end
    for i = 1:t%各个通道都提取
        if strcmp(msgType,'msgFromOrgImage') == 1%嵌入的水印信息来源于载体图像
            fprintf(1,'准备读取 %d 通道的水印信息...\r',i);
            emMsg = readMsgFromMsgFile(msgPath,strcat('msg_',num2str(i),'.txt'),msgLen);
        end
        fprintf(1,'开始提取第 %d 通道的水印信息...\r',i);
        sub_dtImData = dtImData(rowStart:rowEnd,colStart:colEnd,i);
        sub_wmImData = wmImData(rowStart:rowEnd,colStart:colEnd,i);
        if strcmp(vConType,'ZigZag') == 1
            exMsg = giQimDehide_DCT_Glp(sub_dtImData,delta,vlen,p,msgLen);
        else
            exMsg = giQimDehide_DCT_Glp2(sub_dtImData,delta,vlen,p,msgLen);
        end
        [psnr,ber,corr,count] = calcPBC(sub_wmImData,sub_dtImData,bitdepth,emMsg,exMsg,msgLen);%计算PSNR,BER,CORR和COUNT
        fprintf(fid,'第 %d 通道：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\r\n',i,psnr,ber,corr,count);%写入文件
        psnrSum = psnrSum + psnr;berSum = berSum + ber;corrSum = corrSum + corr;countSum = countSum + count;
    end
    fprintf(fid,'平均信息 ：psnr: %.2f ber: %.2f corr: %.2f numOfNotSame: %d\r\n',psnrSum/t,berSum/t,corrSum/t,floor(countSum/t));
    fprintf(fid,'---------------------------------------------------------------------------------------------\r\n');
end
if fid ~= 1
    fclose(fid);
end
fprintf(1,'水印提取完成!\r');

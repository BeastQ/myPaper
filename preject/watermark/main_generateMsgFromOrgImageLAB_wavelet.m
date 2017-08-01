% -------------------------------------------------------------------------
% 此函数的作用: 从原始图像(载体图像)中直接提取水印
% 版本: v1.0
% 作者: WangMian
% 最后编辑:zcr214
% 编辑时间: 2016-06-28
% 说明: 直接从载体提取的水印文件被存放在名为 图像编号_提取时间 的文件夹中;
%       每个通道提取的水印,被保存在名为 msg_图像编号_通道编号_提取时间.txt 文件中;
%       所有提提取水印时的算法参数和图像位置被保存在Readme.txt文件中
% -------------------------------------------------------------------------
% ----设置参数-------------------------------------------------------------
clear all;close all;clc;
vConType =   'ZigZag';%% 'DiagCoeff';%%           %矢量构成方式Zigzag或者DiagCoeff
vlen = 32;p = 2.0;delta = 0.7;%用作嵌入1bit水印的每个子向量的长度，lp-norm的阶，量化步长，提取的位置低频还是高频
imNum = 1;                          %载体图像数量
msgPath = strcat('Input\msg\msgFromOrgImageBy',vConType,'\');%保存直接从载体图像提取出的水印的文件夹路径
msgLen = 128;                       %设置水印信息的长度
% orgImPath = 'Input\orgImage\RGB\';  %原始图像(载体图像)的文件夹路径
orgImPath = 'Input\orgImage\CMYK\';  %原始图像(载体图像)的文件夹路径
orgImFormat = '.tif';               %载体图像的格式
% rowStart = 66;rowEnd = 515;%适用于580大小的图黄蓝和红图，水印区域为450*450
% colStart = 66;colEnd = 515;
rowStart = 26;rowEnd = 185;%使用于210*210的红色酒杯图，水印区域为160*160
colStart = 26;colEnd = 185;
% rowStart = 71;rowEnd = 420;%使用于490*490的红色logo图,水印区域为350*350
% colStart = 71;colEnd = 420;
% rowStart = 26;rowEnd = 537;%使用于567*567的黄蓝图,水印区域为512*512
% colStart = 26;colEnd = 537;
% rowStart = 24;rowEnd = 151;%使用于171*171的红logo图,水印区域为128*128
% colStart = 24;colEnd = 151;
% ----提取水印--------------------------------------------------------------
if ~exist(msgPath) %#ok<EXIST> 
    mkdir(msgPath);% 检测是否存在保存水印数据的文件夹
end
for i = 1 : imNum
    if ~exist(msgPath) %#ok<EXIST>
        mkdir(msgPath);
    end
    %读取载体图像及相关信息
    orgImData = imread(strcat(orgImPath,num2str(i),orgImFormat));
     
    % CMYK --> Lab
    cform1 = makecform('cmyk2srgb'); % cmyk转srgb
    rgb = applycform(orgImData,cform1);
    cform2 = makecform('srgb2lab'); % srgb转lab
    orgImData = applycform(rgb,cform2); 
    
    [m,n,t] = size(orgImData);
    %做小波变换
    [wA,wH,wV,wD]=dwt2(orgImData(rowStart:rowEnd,colStart:colEnd,1),'haar');
%     wA=round(wA);
    wH=round(wH);
    wV=round(wV);
    wD=round(wD); 
    %保存直接从载体图像提取水印信息的相关设置的参数
    fid1 = fopen(strcat(msgPath,'Readme.txt'),'w');
    fprintf(fid1,'---------------------------------------------------\r\n');
    fprintf(fid1,'算法参数:vlen:%d p:%.2f delta:%.2f msgLen:%d\r\n',vlen,p,delta,msgLen);
    fprintf(fid1,'提取水印的载体图像位置:%s\r\n',strcat(orgImPath,num2str(i),orgImFormat));
    fprintf(fid1,'子图信息: 在原图中的位置:rowStart:%d rowEnd:%d colStart:%d colEnd:%d,大小为:%d * %d\r\n',...
    rowStart,rowEnd,colStart,colEnd,(rowEnd-rowStart+1),(colEnd-colStart+1));
    fprintf(fid1,'图像的信息:大小:%d * %d,通道数:%d\r\n',m,n,t);
    fprintf(fid1,'---------------------------------------------------\r\n');
    fclose(fid1);
    %校验读取的载体图像是否是方阵
    if m ~= n
        fprintf(1,'读取错误,载体图像不是方阵,程序终止!\r');
        return ;
    end
    %亮度通道的小波变换3个高频子带提取,并保存在文件中
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
        fprintf(1,'请确认vConType，必须填写Zigzag或者DiagCoeff');
        return;
    end
   
    
end
fprintf(1,'水印生成完毕！\n');

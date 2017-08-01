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
vConType ='DiagCoeff';% 'Zigzag'; %%             %矢量构成方式Zigzag或者DiagCoeff
imNum = 1;                          %载体图像数量
msgPath = strcat('Input\msg\msgFromOrgImageBy',vConType,'\');%保存直接从载体图像提取出的水印的文件夹路径
msgLen = 128;                       %设置水印信息的长度
% orgImPath = 'Input\orgImage\RGB\';  %原始图像(载体图像)的文件夹路径
orgImPath = 'Input\orgImage\CMYK\';  %原始图像(载体图像)的文件夹路径
orgImFormat = '.tif';               %载体图像的格式
vlen = 32;p = 2.0;delta = 0.33;LorH='H';%用作嵌入1bit水印的每个子向量的长度，lp-norm的阶，量化步长，提取的位置低频还是高频
rowStart = 66;rowEnd = 515;
colStart = 66;colEnd = 515;
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
    [m,n,t] = size(orgImData);
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
    %每个通道都提取,并保存在不同的文件中
    for j = 1 : t
        if strcmp(vConType,'ZigZag') == 1
            msg = giQimDehide_DCT_Glp(orgImData(rowStart:rowEnd,colStart:colEnd,j),delta,vlen,p,msgLen,LorH);
        else
            msg = giQimDehide_DCT_Glp2(orgImData(rowStart:rowEnd,colStart:colEnd,j),delta,vlen,p,msgLen,LorH);
        end
        fid2 = fopen(strcat(msgPath,'msg_',num2str(j),'.txt'),'w');
        for k = 1 : msgLen%保存到文件
            fprintf(fid2,'%d\r\n',msg(k));
        end
        fclose(fid2);
    end
end


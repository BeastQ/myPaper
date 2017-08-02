% --------------------------------------------------------------------------------------------------------------
% 此函数的作用: 在亮度空间嵌入水印的主程序,适用的图像模式为CMYK(水印来源于指定文件)
% 版本:         v1.0
% 编辑时间:     2016-06-30
% 作者:         zcr214
% 说明:         在运行此嵌入水印主程序前,请先确认或设置下面的相关参数;
%               请根据自己的实际要求修改参数或程序代码
% --------------------------------------------------------------------------------------------------------------
clear all;close all;clc;
%--------设置相关参数--------------------------------------------------------------------------------------------
vConType = 'ZigZag';  %  % 'ZigZag';      %矢量的构成方式:ZigZag:zigzag扫描 DiagCoeff:反对角线分组

colorSpace='RGB';%'RGB'; %色彩空间

msgOriPath = strcat('Input/msg/msgFromOrgImageBy',vConType,'/'); 
msgRandPath= strcat('Input/msg/Random/'); 

% orgImPath = 'Input\orgImage\RGB\'; %原始图像所在文件夹的路径
orgImPath = ['Input/orgImage/',colorSpace,'/']; %原始图像所在文件夹的路径
orgImFormat = '.tiff';              %原始图像的格式
% wmImPath = strcat('Output\wmImage\RGB\',vConType,'\',msgType,'\');%输出的水印图像保存的文件夹路径
msgLen= 128;                       %设置需读取的水印信息的长度
imgfiles=dir([orgImPath,'*',orgImFormat]);
imNum = length(imgfiles);                         %图像的数量
                                   
bitdepth = 8;vlen = 32;p = 2.0;delta = 0.33;%图像的每通道的位深度，用作嵌入1bit水印的每个子向量的长度，lp-norm的阶，量化步长
sf = 0.99;                          %由于该图像每通道大概有60%的值是为255的,所以对图像每通道的值进行缩放
% rowStart = 66;rowEnd = 515;%适用于580大小的图黄蓝和红图，水印区域为450*450
% colStart = 66;colEnd = 515;
% rowStart = 26;rowEnd = 185;%使用于210*210的红色酒杯图，水印区域为160*160
% colStart = 26;colEnd = 185;
%rowStart = 71;rowEnd = 420;%使用于490*490的红色logo图,水印区域为350*350
%colStart = 71;colEnd = 420;
rowStart = 56;rowEnd = 455;%使用于512*512的lena图,水印区域为400*400
colStart = 56;colEnd = 455;
% rowStart = 26;rowEnd = 537;%使用于567*567的黄蓝图,水印区域为512*512
% colStart = 26;colEnd = 537;
% rowStart = 24;rowEnd = 151;%使用于171*171的红logo图,水印区域为128*128
% colStart = 24;colEnd = 151;

wmImPath = ['Output/wmImage/',colorSpace,'/',vConType,'/delta',num2str(delta),'/'];%输出的水印图像保存的文件夹路径
wmImFormat = '.tiff';               %输出的水印图像的格式(若为jpg格式，则此程序默认保存的图像质量为100（不压缩）；
                                   %若为tif格式，则保存的图像质量分辨率为300并且不压缩;若为其它格式，则按默认的参数保存)

%------进行水印嵌入--------------------------------------
for imName = 1:imNum
    orgImData = imread([orgImPath,imgfiles(imName).name]);%读取原始图像数据
     % CMYK --> Lab
    %cform1 = makecform('cmyk2srgb'); % cmyk转srgb
    %rgb = applycform(orgImData,cform1);
    %cform2 = makecform('srgb2lab'); % srgb转lab
    %orgImData = applycform(rgb,cform2); 
    
    % RGB --> Lab
    cform1 = makecform('srgb2lab'); % srgb转lab
    orgImData = applycform(orgImData,cform1);
    
%     orgImData = orgImData * sf;%对原始图像的颜色值进行缩放,缩放因子为sf
    [m,n,t] = size(orgImData);  
   
    if m ~= n %检测原始图像是否是方形图像
        fprintf(1,'选择的原始(载体)图像大小为:%d*%d,不是方形图像,程序中止!\r',m,n);
        return ;
    end
    %嵌入水印
    emMsgRand= readMsgFromMsgFile(msgRandPath,strcat('msg.txt'),msgLen);
    emMsgwH = readMsgFromMsgFile(msgOriPath,strcat('msg_wH_delta',num2str(delta),'.txt'),msgLen);
    emMsgwV = readMsgFromMsgFile(msgOriPath,strcat('msg_wV_delta',num2str(delta),'.txt'),msgLen);
    emMsgwD = readMsgFromMsgFile(msgOriPath,strcat('msg_wD_delta',num2str(delta),'.txt'),msgLen);
   
    wmImData = orgImData;
    SubOrgImData=orgImData(rowStart:rowEnd,colStart:colEnd,1);
     %做小波变换,得到嵌入水印的目标区域
    [wA,wH,wV,wD]=dwt2(SubOrgImData,'haar');
    wA=round(wA);
    wH=round(wH);
    wV=round(wV);
    wD=round(wD);
      
        if strcmp(vConType,'ZigZag')==1%矢量构成方式为zigzag
            wA = giQimHide_DCT_Glp(wA,emMsgRand,delta,vlen,p,1);
            wH = giQimHide_DCT_Glp(wH,emMsgwH,delta,vlen,p,1);
            wV = giQimHide_DCT_Glp(wV,emMsgwV,delta,vlen,p,1);
            wD = giQimHide_DCT_Glp(wD,emMsgwD,delta,vlen,p,1);

            xx = idwt2(wA,wH,wV,wD,'haar');
            wmImData(rowStart:rowEnd,colStart:colEnd,1)=xx;
        
        elseif strcmp(vConType,'DiagCoeff')==1%矢量构成方式为对角线分组
            wA = giQimHide_DCT_Glp2(wA,emMsgRand,delta,vlen,p,1);
            wH = giQimHide_DCT_Glp2(wH,emMsgwH,delta,vlen,p,1);
            wV = giQimHide_DCT_Glp2(wV,emMsgwV,delta,vlen,p,1);
            wD = giQimHide_DCT_Glp2(wD,emMsgwD,delta,vlen,p,1);
            xx = idwt2(wA,wH,wV,wD,'haar');
            wmImData(rowStart:rowEnd,colStart:colEnd,1)=xx;
        else
            fprintf(1,'请确认vConType，必须填写Zigzag或者DiagCoeff');
            return;
       end
    
%------保存水印图像---------------------------------------------------------
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
        imwrite(wmImDataBorder,[wmImPath,'delta',num2str(delta),imgfiles(imName).name,'_Border_',wmImFormat],'quality',100);%保存加有黑色边框的图像(便于打印扫描后裁剪)
        imwrite(wmImDataBorderSize2,[wmImPath,'delta',num2str(delta),imgfiles(imName).name,'_BorderSize2_',wmImFormat],'quality',100);%保存加有黑色边框的图像(便于打印扫描后裁剪)
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
fprintf(1,'水印嵌入和图像保存完成!\r\r');


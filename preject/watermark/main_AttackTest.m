%main_attackTest
% --------提取水印------------
vConType =  'ZigZag';  %% 'DiagCoeff'; %%    %矢量的构成方式:ZigZag:zigzag扫描 DiagCoeff:反对角线分组
colorSpace='CMYK';%'RGB'; %色彩空间
bitdepth = 8;vlen = 32;p = 2.0;delta = 0.7;%图像的每通道的位深度，用作嵌入1bit水印的每个子向量的长度，lp-norm的阶，量化步长
sf = 0.99;                          %由于该图像每通道大概有60%的值是为255的,所以对图像每通道的值进行缩放
% rowStart = 66;rowEnd = 515;%适用于580大小的图黄蓝和红图，水印区域为450*450
% colStart = 66;colEnd = 515;
% rowStart = 26;rowEnd = 185;%使用于210*210的红色酒杯图，水印区域为160*160
% colStart = 26;colEnd = 185;
% rowStart = 71;rowEnd = 420;%使用于490*490的红色logo图,水印区域为350*350
% colStart = 71;colEnd = 420;
% rowStart = 26;rowEnd = 537;%使用于567*567的黄蓝图,水印区域为512*512
% colStart = 26;colEnd = 537;
rowStart = 24;rowEnd = 151;%使用于171*171的红logo图,水印区域为128*128
colStart = 24;colEnd = 151;
wmImPath = ['Output\wmImage\',colorSpace,'\',vConType,'\delta',num2str(delta),'\'];%输出的水印图像保存的文件夹路径
wmImFormat = '.tif';
imgfiles=dir([wmImPath,'*',wmImFormat]);
num=length(imgfiles);
method = {'no_attack','noise-wiener','dither','stable-scal_0.8','scal','noise-gaussian_10','noise-gaussian_20'};
% 函数调用 
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
        cform1 = makecform('cmyk2srgb'); % cmyk转srgb
        rgb = applycform(stg0,cform1);
        cform2 = makecform('srgb2lab'); % srgb转lab
        stg0 = applycform(rgb,cform2); 
    fid=fopen([wmImPath,imgfiles(n).name,'.txt'],'w');
    for i = 1:1%Len
       
        stg = stg0(rowStart:rowEnd,colStart:colEnd,:);   
       
        stgAttackLab = attack2(stg, method{i});
        
        %得到水印区域dwt子带
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
        % -------计算PSNR,BER和CORR-------------------------------------------
       berwA = getBer(emMsgwA, exMsgwA);
       corrwA = getCorr(emMsgwA, exMsgwA);
       berwH = getBer(emMsgwH, exMsgwH);
       corrwH = getCorr(emMsgwH, exMsgwH);
       berwV = getBer(emMsgwV, exMsgwV);
       corrwV = getCorr(emMsgwV, exMsgwV);
       berwD = getBer(emMsgwD, exMsgwD);
       corrwD = getCorr(emMsgwD, exMsgwD);
       
       
        fprintf(fid,'%s攻击后:\n',method{i});
        fprintf(fid,'wA,berwA: %.2f corrwA: %.2f\n',berwA,corrwA);
        fprintf(fid,'wH,berwH: %.2f corrwH: %.2f\n',berwH,corrwH);
        fprintf(fid,'wV,berwV: %.2f corrwV: %.2f\n',berwV,corrwV);
        fprintf(fid,'wD,berwD: %.2f corrwD: %.2f\n',berwD,corrwD);
        fprintf(fid,'\n');
    end
    fclose(fid);
end
fprintf(1,'水印测试完成!程序自动退出。\n');
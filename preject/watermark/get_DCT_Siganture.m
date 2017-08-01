function SetofSig=get_DCT_Siganture(stg,sidelen,positionR,positionC)
% function [zheng,fu]=DCT_Siganture(stg,sidelen,positionR,positionC)
% stg 目标图像
% sidelen 分块大小边长
% positionR 分块中的位置行标
% positionC 分块中的位置列标
% 返回值，每个分块指定位置的正负系数的集合

sdct=blkproc(stg,[sidelen sidelen],'dct2'); %分块做dct变换
[m,n]=size(sdct);
numR=floor(m/sidelen);
numC=floor(n/sidelen);
SetofSig=zeros(numR,numC);
for r=1:numR
    for c=1:numC
        SetofSig(r,c)=sdct(positionR+sidelen*(r-1),positionC+sidelen*(c-1));      
    end
end
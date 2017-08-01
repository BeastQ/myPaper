function SetofRelation=get_DCT_Relation(stg,sidelen)
% function SetofRelation=get_DCT_Relation(stg,sidelen)
% stg 目标图像
% sidelen 分块大小边长
% 返回值，每个分块(1,3)(2,2)(3,1)的DCT关系
% （1,3）>（2,2）----1    （1,3）<=（2,2）----0
% （2,2）>（3,1）----1    （2,2）<=（3,1）----0
% （3,1）>（1,3）----1    （3,1）<=（1,3）----0

stgdct=blkproc(stg,[sidelen sidelen],'dct2'); %分块做dct变换
sdct=normalization(stgdct,1);%归一化
[m,n]=size(sdct);
numR=floor(m/sidelen);
numC=floor(n/sidelen);
SetofRelation=zeros(numR,numC,3);
for r=1:numR
    for c=1:numC
        % （1,3）大于（2，2）则为1，否则为0
        if sdct(1+sidelen*(r-1),3+sidelen*(c-1))>sdct(2+sidelen*(r-1),2+sidelen*(c-1))
            SetofRelation(r,c,1)=1;
        else
            SetofRelation(r,c,1)=0;
        end
        % （2,2）大于（3，1）则为1，否则为0
        if sdct(2+sidelen*(r-1),2+sidelen*(c-1))>sdct(3+sidelen*(r-1),1+sidelen*(c-1))
            SetofRelation(r,c,2)=1;
        else
            SetofRelation(r,c,2)=0;
        end
        % （3,1）大于（1，3）则为1，否则为0
        if sdct(3+sidelen*(r-1),1+sidelen*(c-1))>sdct(2+sidelen*(r-1),2+sidelen*(c-1))
            SetofRelation(r,c,3)=1;
        else
            SetofRelation(r,c,3)=0;
        end  
    end
end


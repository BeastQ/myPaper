function SetofRelation=get_DCT_Relation(stg,sidelen)
% function SetofRelation=get_DCT_Relation(stg,sidelen)
% stg Ŀ��ͼ��
% sidelen �ֿ��С�߳�
% ����ֵ��ÿ���ֿ�(1,3)(2,2)(3,1)��DCT��ϵ
% ��1,3��>��2,2��----1    ��1,3��<=��2,2��----0
% ��2,2��>��3,1��----1    ��2,2��<=��3,1��----0
% ��3,1��>��1,3��----1    ��3,1��<=��1,3��----0

stgdct=blkproc(stg,[sidelen sidelen],'dct2'); %�ֿ���dct�任
sdct=normalization(stgdct,1);%��һ��
[m,n]=size(sdct);
numR=floor(m/sidelen);
numC=floor(n/sidelen);
SetofRelation=zeros(numR,numC,3);
for r=1:numR
    for c=1:numC
        % ��1,3�����ڣ�2��2����Ϊ1������Ϊ0
        if sdct(1+sidelen*(r-1),3+sidelen*(c-1))>sdct(2+sidelen*(r-1),2+sidelen*(c-1))
            SetofRelation(r,c,1)=1;
        else
            SetofRelation(r,c,1)=0;
        end
        % ��2,2�����ڣ�3��1����Ϊ1������Ϊ0
        if sdct(2+sidelen*(r-1),2+sidelen*(c-1))>sdct(3+sidelen*(r-1),1+sidelen*(c-1))
            SetofRelation(r,c,2)=1;
        else
            SetofRelation(r,c,2)=0;
        end
        % ��3,1�����ڣ�1��3����Ϊ1������Ϊ0
        if sdct(3+sidelen*(r-1),1+sidelen*(c-1))>sdct(2+sidelen*(r-1),2+sidelen*(c-1))
            SetofRelation(r,c,3)=1;
        else
            SetofRelation(r,c,3)=0;
        end  
    end
end


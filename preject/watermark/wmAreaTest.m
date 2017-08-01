function wmAreaTest(dataPath,TestMethod)

matfiles=dir([dataPath,'*.mat']);

%-------------------------------------------------------------------------------
%水印区域图像，计算空域能量均值
if strcmp(TestMethod,'PartialMeanEnergy')==1
    fid=fopen([dataPath,'PartialMeanEnergy.txt'],'w');
    for i=1:length(matfiles) 
        fprintf(fid,['\n',matfiles(i).name,'能量均值\n']);
        load([dataPath,matfiles(i).name]);
        [m,n,w]=size(wmArea);
        for t=1:w
            stg=wmArea(:,:,t);
            Engy=double(stg).^2;
            mEngy=mean(Engy(:));
%           fprintf(fid,'通道%d的能量均值为%d\n',t,mEngy);

            orgL=gauLowPass(stg,3,0.5);%低频部分（gauLowPass返回的是uint8类型的数据）
             orgH=stg-orgL;%高频部分
             orgL=normalization(orgL,1);
             EngyL=double(orgL).^2;
             mEngyL=mean(EngyL(:));
             orgH=normalization(orgH,1);
             EngyH=double(orgH).^2;
             mEngyH=mean(EngyH(:));
            fprintf(fid,'通道%d的能量均值为%d，低频%d,高频%d\n',t,mEngy,mEngyL,mEngyH);
        end
    end;
    if fid ~= 1
        fclose(fid);
    end
end

% orgL=gauLowPass(orgImData,3,0.5);%低频部分（gauLowPass返回的是uint8类型的数据）
% orgH=orgImData-orgL;%高频部分
%-------------------------------------------------------------------------------
% 求DCT系数的正负个数及差值
if strcmp(TestMethod,'DCT_Signature')==1
    fid=fopen([dataPath,'DCT±Signature.txt'],'w');
    for i=1:length(matfiles)
        fprintf(fid,['\n',matfiles(i).name,'DCT正负系数个数\n']);
        load([dataPath,matfiles(i).name]);
        [m,n,w]=size(wmArea);
        for t=1:w
                stg=wmArea(:,:,t);
                SetofSig=get_DCT_Siganture(stg,8,3,1);%在8*8的小块中，选取（3,1）位置的dct系数，观察正负个数值
                x=sum(SetofSig(:)>0);%大于0的系数的个数
                y=sum(SetofSig(:)<0);%小于0的系数的个数
                Diff=y-x;
                fprintf(fid,'通道%d的DCT正值%d个，负值%d个,差值为%d\n',t,x,y,Diff);
        end
    end
    if fid~=1
        fclose(fid);
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 获取并保存 DCT系数关系
if strcmp(TestMethod,'save_DCT_Relation_RGB')==1
    for i=1:length(matfiles)
        load([dataPath,matfiles(i).name]);
       
        stg1=wmArea(:,:,1);
        SetofRelation1=get_DCT_Relation(stg1,8);%在8*8的小块中，观察（1,3,）（2，2）（3,1）三个位置的DCT系数大小关系
        stg2=wmArea(:,:,2);
        SetofRelation2=get_DCT_Relation(stg2,8);%在8*8的小块中，观察（1,3,）（2，2）（3,1）三个位置的DCT系数大小关系
        stg3=wmArea(:,:,3);
        SetofRelation3=get_DCT_Relation(stg3,8);%在8*8的小块中，观察（1,3,）（2，2）（3,1）三个位置的DCT系数大小关系       
        %保存关系
        save([dataPath,'DCTRelation_',matfiles(i).name],'SetofRelation1','SetofRelation2','SetofRelation3');
         end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 获取并保存 DCT系数关系
if strcmp(TestMethod,'save_DCT_Relation_CMYK')==1
    for i=1:length(matfiles)
        load([dataPath,matfiles(i).name]);
       
        stg1=wmArea(:,:,1);
        SetofRelation=get_DCT_Relation(stg1,8);%在8*8的小块中，观察（1,3,）（2，2）（3,1）三个位置的DCT系数大小关系
        %保存关系
       save([dataPath,'DCTRelation_',matfiles(i).name],'SetofRelation');
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 比较根据DCT系数关系，统计原图与印刷图，复印图，PS再处理图的差异度，并画图展示
if strcmp(TestMethod,'show_DCT_Relation_RGB')==1
   [num dctRelat]=xlsread([dataPath,'MatofDCTRelation.xlsx']);
   [num name]=size(dctRelat);
   for i=1:num%图像数量
        fid=fopen([dataPath,dctRelat{i,1},'.txt'],'w');%用于写入差异度为0所占的比例
        
        load([dataPath,dctRelat{i,1},'.mat']);%原图
        o1=SetofRelation1;
        o2=SetofRelation2;
        o3=SetofRelation3;
        
        load([dataPath,dctRelat{i,2},'.mat']);%印刷
        p1=SetofRelation1;
        p2=SetofRelation2;
        p3=SetofRelation3;
        
        load([dataPath,dctRelat{i,3},'.mat']);%复印
        c1=SetofRelation1;
        c2=SetofRelation2;
        c3=SetofRelation3;
        
        load([dataPath,dctRelat{i,4},'.mat']);%PS再处理
        x1=SetofRelation1;
        x2=SetofRelation2;
        x3=SetofRelation3;
        
      
        %********第一通道*********
        %************************
        RelatDiffop1=RelationDiff(o1,p1);%计算差异度
       
      %  ShowBar3ByHeight(RelatDiffop1,'RelatDiff origion&print channel 1');%画图
      
        RelatDiffoc1=RelationDiff(o1,c1);
      %  ShowBar3ByHeight(RelatDiffoc1,'RelatDiff origion&copy channel 1');
       
        RelatDiffox1=RelationDiff(o1,x1);
     %   ShowBar3ByHeight(RelatDiffox1,'RelatDiff origion&PS fixed channel 1');
       
       
        fprintf(fid,'第一通道----------------------------------------------------\n');
        %计算差异度均值
        fprintf(fid,'op差异度是%f\n',mean(RelatDiffop1(:)));
        fprintf(fid,'oc差异度是%f\n',mean(RelatDiffoc1(:)));
        fprintf(fid,'ox差异度是%f\n\n',mean(RelatDiffox1(:)));
        
        %计算差异度0和1占总体的比例
         [m,n]=size(RelatDiffop1);%得到差异度矩阵的大小，对于23通道也适用
         
%         fprintf(fid,'op差异度0,1比例是%f\n',(sum(RelatDiffop1(:)==0)+sum(RelatDiffop1(:)==1))/(m*n));
%         fprintf(fid,'oc差异度0,1比例是%f\n',(sum(RelatDiffoc1(:)==0)+sum(RelatDiffoc1(:)==1))/(m*n));
%         fprintf(fid,'ox差异度0,1比例是%f\n\n',(sum(RelatDiffox1(:)==0)+sum(RelatDiffox1(:)==1))/(m*n));
%        利用0和1占总体比例不可行
 
       %计算差异度为0占所有关系系数的比例
        fprintf(fid,'RelatDiff origion&print channel 1 差异度为0的比例是%f\n',(sum(RelatDiffop1(:)==0))/(m*n));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&copy channel 1 差异度为0的比例是%f\n',sum(RelatDiffoc1(:)==0)/(m*n));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&PS fixed channel 1 差异度为0的比例是%f\n\n',sum(RelatDiffox1(:)==0)/(m*n));%计算差异度为0的比例
      
        %计算差异度最0与3的比例
        fprintf(fid,'RelatDiff origion&print channel 1 差异度为0与3的比例是%f\n',(sum(RelatDiffop1(:)==0))/(sum(RelatDiffop1(:)==3)));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&copy channel 1 差异度为0与3的比例是%f\n',(sum(RelatDiffoc1(:)==0))/(sum(RelatDiffoc1(:)==3)));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&PS fixed channel 1 差异度为0与3的比例是%f\n\n',(sum(RelatDiffox1(:)==0))/(sum(RelatDiffox1(:)==3)));%计算差异度为0的比例
        
         %*********第二通道********
         %************************
        RelatDiffop2=RelationDiff(o2,p2);
      %  ShowBar3ByHeight(RelatDiffop2,'RelatDiff origion&print channel 2');
        
        RelatDiffoc2=RelationDiff(o2,c2);
       % ShowBar3ByHeight(RelatDiffoc2,'RelatDiff origion&copy channel 2');
       
        RelatDiffox2=RelationDiff(o2,x2);
     %   ShowBar3ByHeight(RelatDiffox2,'RelatDiff origion&PS fixed channel 2');
       
        %计算差异度为0占所有关系系数的比例
        fprintf(fid,'第二通道----------------------------------------------------\n');
        fprintf(fid,'RelatDiff origion&print channel 2 差异度为0的比例是%f\n',(sum(RelatDiffop2(:)==0))/(m*n));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&copy channel 2 差异度为0的比例是%f\n',sum(RelatDiffoc2(:)==0)/(m*n));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&PS fixed channel 2 差异度为0的比例是%f\n\n',sum(RelatDiffox2(:)==0)/(m*n));%计算差异度为0的比例
        %计算差异度最小与最大的比例
        fprintf(fid,'RelatDiff origion&print channel 2 差异度为0与3的比例是%f\n',(sum(RelatDiffop2(:)==0))/(sum(RelatDiffop2(:)==3)));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&copy channel 2 差异度为0与3的比例是%f\n',(sum(RelatDiffoc2(:)==0))/(sum(RelatDiffoc2(:)==3)));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&PS fixed channel 2 差异度为0与3的比例是%f\n\n',(sum(RelatDiffox2(:)==0))/(sum(RelatDiffox2(:)==3)));%计算差异度为0的比例
       
      %********第三通道**********
      %************************
        RelatDiffop3=RelationDiff(o3,p3);
       % ShowBar3ByHeight(RelatDiffop3,'RelatDiff origion&print channel 3');
      
        RelatDiffoc3=RelationDiff(o3,c3);
      %  ShowBar3ByHeight(RelatDiffoc3,'RelatDiff origion&copy channel 3');
       
        RelatDiffox3=RelationDiff(o3,x3);
        %ShowBar3ByHeight(RelatDiffox3,'RelatDiff origion&PS fixed channel 3');
        
        %计算差异度为0占所有关系系数的比例
        fprintf(fid,'第三通道----------------------------------------------------\n');
        fprintf(fid,'RelatDiff origion&print channel 3 差异度为0的比例是%f\n',(sum(RelatDiffop3(:)==0))/(m*n));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&copy channel 3 差异度为0的比例是%f\n',sum(RelatDiffoc3(:)==0)/(m*n));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&PS fixed channel 3 差异度为0的比例是%f\n\n',sum(RelatDiffox3(:)==0)/(m*n));%计算差异度为0的比例
        %计算差异度最小与最大的比例
        fprintf(fid,'RelatDiff origion&print channel 3 差异度为0与3的比例是%f\n',(sum(RelatDiffop3(:)==0))/(sum(RelatDiffop3(:)==3)));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&copy channel 3 差异度为0与3的比例是%f\n',(sum(RelatDiffoc3(:)==0))/(sum(RelatDiffoc3(:)==3)));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&PS fixed channel 3 差异度为0与3的比例是%f\n\n',(sum(RelatDiffox3(:)==0))/(sum(RelatDiffox3(:)==3)));%计算差异度为0的比例
        if fid~=1
        fclose(fid);
        end
   end
   
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 比较根据DCT系数关系，统计原图与印刷图，复印图，PS再处理图的差异度，并画图展示
if strcmp(TestMethod,'show_DCT_Relation_CMYK')==1
   [num dctRelat]=xlsread([dataPath,'MatofDCTRelation.xlsx']);
   [num name]=size(dctRelat);
   for i=1:num%图像数量
        fid=fopen([dataPath,dctRelat{i,1},'.txt'],'w');%用于写入差异度为0所占的比例
        
        load([dataPath,dctRelat{i,1},'.mat']);%原图
        o=SetofRelation;
               
        load([dataPath,dctRelat{i,2},'.mat']);%印刷
        p=SetofRelation;
              
        load([dataPath,dctRelat{i,3},'.mat']);%复印
        c=SetofRelation;
              
%         load([dataPath,dctRelat{i,4},'.mat']);%PS再处理
%         x=SetofRelation1;

        RelatDiffop=RelationDiff(o,p);%计算差异度
        ShowBar3ByHeight(RelatDiffop,'RelatDiff origion&print');%画图
      
        RelatDiffoc=RelationDiff(o,c);
       ShowBar3ByHeight(RelatDiffoc,'RelatDiff origion&copy');
       
%         RelatDiffox=RelationDiff(o,x);
%        ShowBar3ByHeight(RelatDiffox,'RelatDiff origion&PS fixed channel');
%        
       
        fprintf(fid,'----------------------------------------------------\n');
        %计算差异度均值
        fprintf(fid,'op差异度是%f\n',mean(RelatDiffop(:)));
        fprintf(fid,'oc差异度是%f\n',mean(RelatDiffoc(:)));
%         fprintf(fid,'ox差异度是%f\n\n',mean(RelatDiffox(:)));
        
        %计算差异度0和1占总体的比例
         [m,n]=size(RelatDiffop);%得到差异度矩阵的大小，对于23通道也适用
 
       %计算差异度为0占所有关系系数的比例
        fprintf(fid,'RelatDiff origion&print差异度为0的比例是%f\n',(sum(RelatDiffop(:)==0))/(m*n));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&copy差异度为0的比例是%f\n',sum(RelatDiffoc(:)==0)/(m*n));%计算差异度为0的比例
%         fprintf(fid,'RelatDiff origion&PS fixed channel差异度为0的比例是%f\n\n',sum(RelatDiffox1(:)==0)/(m*n));%计算差异度为0的比例      
        fprintf(fid,'RelatDiff origion&print差异度为3的比例是%f\n',(sum(RelatDiffop(:)==3))/(m*n));%计算差异度为0的比例
        fprintf(fid,'RelatDiff origion&copy差异度为3的比例是%f\n',sum(RelatDiffoc(:)==3)/(m*n));%计算差异度为0的比例

        if fid~=1
        fclose(fid);
        end
   end
   
end
%--------------------------------------------------------------------------
% patchwork 亮度测试
if strcmp(TestMethod,'PatchworkTest')==1
%   注意本例，1.和2.最好分开进行，生成好随机数之后，不要再变更。
% %    1.保存10组随机数
%    load([dataPath,matfiles(1).name]);
%     [m,n,t]=size(wmArea);
%     randSet=zeros(10,m*n);
%     for i=1:10
%         randSet(i,:)=randperm(m*n);
%     end
%     save([dataPath,'\randSet\randSet.mat'],'randSet');

% %    2. 对每张图片使用十次随机，patchwork测试，并求均值。
    fid=fopen([dataPath,'patchworkTest.txt'],'w');
    load([dataPath,'\randSet\randSet.mat']);
    for i=1:length(matfiles)
       
        load([dataPath,matfiles(i).name]);
        fprintf(fid,['---------------------\n',matfiles(i).name,'\n']);
        for t=1:3
             stg=wmArea(:,:,t);
             patchTestDiff=0;
             for n=1:10
                patchTestDiff=patchTestDiff+patchworkTest(stg,randSet(n,:));%
             end
             patchTestDiff=floor(patchTestDiff/10);
             fprintf(fid,'第%d通道亮度差值为:%d\n',t,patchTestDiff);
        end
    end
    if fid~=1
        fclose(fid);
    end
end





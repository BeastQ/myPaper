function wmAreaTest(dataPath,TestMethod)

matfiles=dir([dataPath,'*.mat']);

%-------------------------------------------------------------------------------
%ˮӡ����ͼ�񣬼������������ֵ
if strcmp(TestMethod,'PartialMeanEnergy')==1
    fid=fopen([dataPath,'PartialMeanEnergy.txt'],'w');
    for i=1:length(matfiles) 
        fprintf(fid,['\n',matfiles(i).name,'������ֵ\n']);
        load([dataPath,matfiles(i).name]);
        [m,n,w]=size(wmArea);
        for t=1:w
            stg=wmArea(:,:,t);
            Engy=double(stg).^2;
            mEngy=mean(Engy(:));
%           fprintf(fid,'ͨ��%d��������ֵΪ%d\n',t,mEngy);

            orgL=gauLowPass(stg,3,0.5);%��Ƶ���֣�gauLowPass���ص���uint8���͵����ݣ�
             orgH=stg-orgL;%��Ƶ����
             orgL=normalization(orgL,1);
             EngyL=double(orgL).^2;
             mEngyL=mean(EngyL(:));
             orgH=normalization(orgH,1);
             EngyH=double(orgH).^2;
             mEngyH=mean(EngyH(:));
            fprintf(fid,'ͨ��%d��������ֵΪ%d����Ƶ%d,��Ƶ%d\n',t,mEngy,mEngyL,mEngyH);
        end
    end;
    if fid ~= 1
        fclose(fid);
    end
end

% orgL=gauLowPass(orgImData,3,0.5);%��Ƶ���֣�gauLowPass���ص���uint8���͵����ݣ�
% orgH=orgImData-orgL;%��Ƶ����
%-------------------------------------------------------------------------------
% ��DCTϵ����������������ֵ
if strcmp(TestMethod,'DCT_Signature')==1
    fid=fopen([dataPath,'DCT��Signature.txt'],'w');
    for i=1:length(matfiles)
        fprintf(fid,['\n',matfiles(i).name,'DCT����ϵ������\n']);
        load([dataPath,matfiles(i).name]);
        [m,n,w]=size(wmArea);
        for t=1:w
                stg=wmArea(:,:,t);
                SetofSig=get_DCT_Siganture(stg,8,3,1);%��8*8��С���У�ѡȡ��3,1��λ�õ�dctϵ�����۲���������ֵ
                x=sum(SetofSig(:)>0);%����0��ϵ���ĸ���
                y=sum(SetofSig(:)<0);%С��0��ϵ���ĸ���
                Diff=y-x;
                fprintf(fid,'ͨ��%d��DCT��ֵ%d������ֵ%d��,��ֵΪ%d\n',t,x,y,Diff);
        end
    end
    if fid~=1
        fclose(fid);
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% ��ȡ������ DCTϵ����ϵ
if strcmp(TestMethod,'save_DCT_Relation_RGB')==1
    for i=1:length(matfiles)
        load([dataPath,matfiles(i).name]);
       
        stg1=wmArea(:,:,1);
        SetofRelation1=get_DCT_Relation(stg1,8);%��8*8��С���У��۲죨1,3,����2��2����3,1������λ�õ�DCTϵ����С��ϵ
        stg2=wmArea(:,:,2);
        SetofRelation2=get_DCT_Relation(stg2,8);%��8*8��С���У��۲죨1,3,����2��2����3,1������λ�õ�DCTϵ����С��ϵ
        stg3=wmArea(:,:,3);
        SetofRelation3=get_DCT_Relation(stg3,8);%��8*8��С���У��۲죨1,3,����2��2����3,1������λ�õ�DCTϵ����С��ϵ       
        %�����ϵ
        save([dataPath,'DCTRelation_',matfiles(i).name],'SetofRelation1','SetofRelation2','SetofRelation3');
         end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% ��ȡ������ DCTϵ����ϵ
if strcmp(TestMethod,'save_DCT_Relation_CMYK')==1
    for i=1:length(matfiles)
        load([dataPath,matfiles(i).name]);
       
        stg1=wmArea(:,:,1);
        SetofRelation=get_DCT_Relation(stg1,8);%��8*8��С���У��۲죨1,3,����2��2����3,1������λ�õ�DCTϵ����С��ϵ
        %�����ϵ
       save([dataPath,'DCTRelation_',matfiles(i).name],'SetofRelation');
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% �Ƚϸ���DCTϵ����ϵ��ͳ��ԭͼ��ӡˢͼ����ӡͼ��PS�ٴ���ͼ�Ĳ���ȣ�����ͼչʾ
if strcmp(TestMethod,'show_DCT_Relation_RGB')==1
   [num dctRelat]=xlsread([dataPath,'MatofDCTRelation.xlsx']);
   [num name]=size(dctRelat);
   for i=1:num%ͼ������
        fid=fopen([dataPath,dctRelat{i,1},'.txt'],'w');%����д������Ϊ0��ռ�ı���
        
        load([dataPath,dctRelat{i,1},'.mat']);%ԭͼ
        o1=SetofRelation1;
        o2=SetofRelation2;
        o3=SetofRelation3;
        
        load([dataPath,dctRelat{i,2},'.mat']);%ӡˢ
        p1=SetofRelation1;
        p2=SetofRelation2;
        p3=SetofRelation3;
        
        load([dataPath,dctRelat{i,3},'.mat']);%��ӡ
        c1=SetofRelation1;
        c2=SetofRelation2;
        c3=SetofRelation3;
        
        load([dataPath,dctRelat{i,4},'.mat']);%PS�ٴ���
        x1=SetofRelation1;
        x2=SetofRelation2;
        x3=SetofRelation3;
        
      
        %********��һͨ��*********
        %************************
        RelatDiffop1=RelationDiff(o1,p1);%��������
       
      %  ShowBar3ByHeight(RelatDiffop1,'RelatDiff origion&print channel 1');%��ͼ
      
        RelatDiffoc1=RelationDiff(o1,c1);
      %  ShowBar3ByHeight(RelatDiffoc1,'RelatDiff origion&copy channel 1');
       
        RelatDiffox1=RelationDiff(o1,x1);
     %   ShowBar3ByHeight(RelatDiffox1,'RelatDiff origion&PS fixed channel 1');
       
       
        fprintf(fid,'��һͨ��----------------------------------------------------\n');
        %�������Ⱦ�ֵ
        fprintf(fid,'op�������%f\n',mean(RelatDiffop1(:)));
        fprintf(fid,'oc�������%f\n',mean(RelatDiffoc1(:)));
        fprintf(fid,'ox�������%f\n\n',mean(RelatDiffox1(:)));
        
        %��������0��1ռ����ı���
         [m,n]=size(RelatDiffop1);%�õ�����Ⱦ���Ĵ�С������23ͨ��Ҳ����
         
%         fprintf(fid,'op�����0,1������%f\n',(sum(RelatDiffop1(:)==0)+sum(RelatDiffop1(:)==1))/(m*n));
%         fprintf(fid,'oc�����0,1������%f\n',(sum(RelatDiffoc1(:)==0)+sum(RelatDiffoc1(:)==1))/(m*n));
%         fprintf(fid,'ox�����0,1������%f\n\n',(sum(RelatDiffox1(:)==0)+sum(RelatDiffox1(:)==1))/(m*n));
%        ����0��1ռ�������������
 
       %��������Ϊ0ռ���й�ϵϵ���ı���
        fprintf(fid,'RelatDiff origion&print channel 1 �����Ϊ0�ı�����%f\n',(sum(RelatDiffop1(:)==0))/(m*n));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&copy channel 1 �����Ϊ0�ı�����%f\n',sum(RelatDiffoc1(:)==0)/(m*n));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&PS fixed channel 1 �����Ϊ0�ı�����%f\n\n',sum(RelatDiffox1(:)==0)/(m*n));%��������Ϊ0�ı���
      
        %����������0��3�ı���
        fprintf(fid,'RelatDiff origion&print channel 1 �����Ϊ0��3�ı�����%f\n',(sum(RelatDiffop1(:)==0))/(sum(RelatDiffop1(:)==3)));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&copy channel 1 �����Ϊ0��3�ı�����%f\n',(sum(RelatDiffoc1(:)==0))/(sum(RelatDiffoc1(:)==3)));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&PS fixed channel 1 �����Ϊ0��3�ı�����%f\n\n',(sum(RelatDiffox1(:)==0))/(sum(RelatDiffox1(:)==3)));%��������Ϊ0�ı���
        
         %*********�ڶ�ͨ��********
         %************************
        RelatDiffop2=RelationDiff(o2,p2);
      %  ShowBar3ByHeight(RelatDiffop2,'RelatDiff origion&print channel 2');
        
        RelatDiffoc2=RelationDiff(o2,c2);
       % ShowBar3ByHeight(RelatDiffoc2,'RelatDiff origion&copy channel 2');
       
        RelatDiffox2=RelationDiff(o2,x2);
     %   ShowBar3ByHeight(RelatDiffox2,'RelatDiff origion&PS fixed channel 2');
       
        %��������Ϊ0ռ���й�ϵϵ���ı���
        fprintf(fid,'�ڶ�ͨ��----------------------------------------------------\n');
        fprintf(fid,'RelatDiff origion&print channel 2 �����Ϊ0�ı�����%f\n',(sum(RelatDiffop2(:)==0))/(m*n));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&copy channel 2 �����Ϊ0�ı�����%f\n',sum(RelatDiffoc2(:)==0)/(m*n));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&PS fixed channel 2 �����Ϊ0�ı�����%f\n\n',sum(RelatDiffox2(:)==0)/(m*n));%��������Ϊ0�ı���
        %����������С�����ı���
        fprintf(fid,'RelatDiff origion&print channel 2 �����Ϊ0��3�ı�����%f\n',(sum(RelatDiffop2(:)==0))/(sum(RelatDiffop2(:)==3)));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&copy channel 2 �����Ϊ0��3�ı�����%f\n',(sum(RelatDiffoc2(:)==0))/(sum(RelatDiffoc2(:)==3)));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&PS fixed channel 2 �����Ϊ0��3�ı�����%f\n\n',(sum(RelatDiffox2(:)==0))/(sum(RelatDiffox2(:)==3)));%��������Ϊ0�ı���
       
      %********����ͨ��**********
      %************************
        RelatDiffop3=RelationDiff(o3,p3);
       % ShowBar3ByHeight(RelatDiffop3,'RelatDiff origion&print channel 3');
      
        RelatDiffoc3=RelationDiff(o3,c3);
      %  ShowBar3ByHeight(RelatDiffoc3,'RelatDiff origion&copy channel 3');
       
        RelatDiffox3=RelationDiff(o3,x3);
        %ShowBar3ByHeight(RelatDiffox3,'RelatDiff origion&PS fixed channel 3');
        
        %��������Ϊ0ռ���й�ϵϵ���ı���
        fprintf(fid,'����ͨ��----------------------------------------------------\n');
        fprintf(fid,'RelatDiff origion&print channel 3 �����Ϊ0�ı�����%f\n',(sum(RelatDiffop3(:)==0))/(m*n));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&copy channel 3 �����Ϊ0�ı�����%f\n',sum(RelatDiffoc3(:)==0)/(m*n));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&PS fixed channel 3 �����Ϊ0�ı�����%f\n\n',sum(RelatDiffox3(:)==0)/(m*n));%��������Ϊ0�ı���
        %����������С�����ı���
        fprintf(fid,'RelatDiff origion&print channel 3 �����Ϊ0��3�ı�����%f\n',(sum(RelatDiffop3(:)==0))/(sum(RelatDiffop3(:)==3)));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&copy channel 3 �����Ϊ0��3�ı�����%f\n',(sum(RelatDiffoc3(:)==0))/(sum(RelatDiffoc3(:)==3)));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&PS fixed channel 3 �����Ϊ0��3�ı�����%f\n\n',(sum(RelatDiffox3(:)==0))/(sum(RelatDiffox3(:)==3)));%��������Ϊ0�ı���
        if fid~=1
        fclose(fid);
        end
   end
   
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% �Ƚϸ���DCTϵ����ϵ��ͳ��ԭͼ��ӡˢͼ����ӡͼ��PS�ٴ���ͼ�Ĳ���ȣ�����ͼչʾ
if strcmp(TestMethod,'show_DCT_Relation_CMYK')==1
   [num dctRelat]=xlsread([dataPath,'MatofDCTRelation.xlsx']);
   [num name]=size(dctRelat);
   for i=1:num%ͼ������
        fid=fopen([dataPath,dctRelat{i,1},'.txt'],'w');%����д������Ϊ0��ռ�ı���
        
        load([dataPath,dctRelat{i,1},'.mat']);%ԭͼ
        o=SetofRelation;
               
        load([dataPath,dctRelat{i,2},'.mat']);%ӡˢ
        p=SetofRelation;
              
        load([dataPath,dctRelat{i,3},'.mat']);%��ӡ
        c=SetofRelation;
              
%         load([dataPath,dctRelat{i,4},'.mat']);%PS�ٴ���
%         x=SetofRelation1;

        RelatDiffop=RelationDiff(o,p);%��������
        ShowBar3ByHeight(RelatDiffop,'RelatDiff origion&print');%��ͼ
      
        RelatDiffoc=RelationDiff(o,c);
       ShowBar3ByHeight(RelatDiffoc,'RelatDiff origion&copy');
       
%         RelatDiffox=RelationDiff(o,x);
%        ShowBar3ByHeight(RelatDiffox,'RelatDiff origion&PS fixed channel');
%        
       
        fprintf(fid,'----------------------------------------------------\n');
        %�������Ⱦ�ֵ
        fprintf(fid,'op�������%f\n',mean(RelatDiffop(:)));
        fprintf(fid,'oc�������%f\n',mean(RelatDiffoc(:)));
%         fprintf(fid,'ox�������%f\n\n',mean(RelatDiffox(:)));
        
        %��������0��1ռ����ı���
         [m,n]=size(RelatDiffop);%�õ�����Ⱦ���Ĵ�С������23ͨ��Ҳ����
 
       %��������Ϊ0ռ���й�ϵϵ���ı���
        fprintf(fid,'RelatDiff origion&print�����Ϊ0�ı�����%f\n',(sum(RelatDiffop(:)==0))/(m*n));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&copy�����Ϊ0�ı�����%f\n',sum(RelatDiffoc(:)==0)/(m*n));%��������Ϊ0�ı���
%         fprintf(fid,'RelatDiff origion&PS fixed channel�����Ϊ0�ı�����%f\n\n',sum(RelatDiffox1(:)==0)/(m*n));%��������Ϊ0�ı���      
        fprintf(fid,'RelatDiff origion&print�����Ϊ3�ı�����%f\n',(sum(RelatDiffop(:)==3))/(m*n));%��������Ϊ0�ı���
        fprintf(fid,'RelatDiff origion&copy�����Ϊ3�ı�����%f\n',sum(RelatDiffoc(:)==3)/(m*n));%��������Ϊ0�ı���

        if fid~=1
        fclose(fid);
        end
   end
   
end
%--------------------------------------------------------------------------
% patchwork ���Ȳ���
if strcmp(TestMethod,'PatchworkTest')==1
%   ע�Ȿ����1.��2.��÷ֿ����У����ɺ������֮�󣬲�Ҫ�ٱ����
% %    1.����10�������
%    load([dataPath,matfiles(1).name]);
%     [m,n,t]=size(wmArea);
%     randSet=zeros(10,m*n);
%     for i=1:10
%         randSet(i,:)=randperm(m*n);
%     end
%     save([dataPath,'\randSet\randSet.mat'],'randSet');

% %    2. ��ÿ��ͼƬʹ��ʮ�������patchwork���ԣ������ֵ��
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
             fprintf(fid,'��%dͨ�����Ȳ�ֵΪ:%d\n',t,patchTestDiff);
        end
    end
    if fid~=1
        fclose(fid);
    end
end





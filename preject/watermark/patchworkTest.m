function A=patchworkTest(stg,RandSet)
  I=double(stg);%��ȡԴͼ��
   [m,n]=size(I);
   r1=RandSet;%���������
   number=m*n;
   a=r1(1:number/2);%ȡǰһ����Ϊ����A
   b=r1(number/2+1:number);%ȡ��һ����Ϊ����B����֤A.B������ȣ�
   pre=I(a(:));
   post=I(b(:));
   preSum=sum(pre(:));
   postSum=sum(post(:));
   A=preSum-postSum;
%    fprintf(1,'diff is %f',A);


%    for j=1:number/2   
%       I(a(j))=I(a(j))+1;%A�������ؼ�1
%    end
%    for m=1:number/2   
%       I(b(m))=I(b(m))-1;%B�������ؼ�1
%    end
%    imshow(I,[]);%��ʾˮӡͼ��
%    imshow(I);%��ʾˮӡͼ��
%    Q1=uint8(I);%��ˮӡͼ������ļ�
%    Q2=double(Q1);%��ȡˮӡͼ��
%    A=Q2-Q1;
% A=double(stg)-I;
% x=mean(A(:));
% fprintf(1,'mean is %f',x);
end




      
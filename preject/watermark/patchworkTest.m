function A=patchworkTest(stg,RandSet)
  I=double(stg);%读取源图像
   [m,n]=size(I);
   r1=RandSet;%生成随机数
   number=m*n;
   a=r1(1:number/2);%取前一半作为集合A
   b=r1(number/2+1:number);%取后一半作为集合B（保证A.B集合相等）
   pre=I(a(:));
   post=I(b(:));
   preSum=sum(pre(:));
   postSum=sum(post(:));
   A=preSum-postSum;
%    fprintf(1,'diff is %f',A);


%    for j=1:number/2   
%       I(a(j))=I(a(j))+1;%A集合像素加1
%    end
%    for m=1:number/2   
%       I(b(m))=I(b(m))-1;%B集合像素减1
%    end
%    imshow(I,[]);%显示水印图像
%    imshow(I);%显示水印图像
%    Q1=uint8(I);%将水印图像存入文件
%    Q2=double(Q1);%读取水印图像
%    A=Q2-Q1;
% A=double(stg)-I;
% x=mean(A(:));
% fprintf(1,'mean is %f',x);
end




      
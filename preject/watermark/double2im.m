function img=double2im(target)
[m,n]=size(target);
img=zeros(m,n);
img(:,:)=round(target(:,:)*255);
img=int16(img);
% img=uint8(img);

function RelatDiff=RelationDiff(dst,src)
% 注意dst和src的维度请保持一致
% dst src 两个3维矩阵，1,2维表示位置，3维是需要计算的关系值
% RelatDiff返回一个2维矩阵，表示差异度
[m,n,t]=size(dst);
RelatDiff=zeros(m,n);%原图与印刷图的关系
temp(:,:,1:t)=xor(dst(:,:,1:t),src(:,:,1:t));%计算关系差异异或
for x=1:m
    for y=1:n   
        RelatDiff(x,y)=sum(temp(x,y,1:t));%如果二者差异越大，则该值越大
    end
end

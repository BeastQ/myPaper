function RelatDiff=RelationDiff(dst,src)
% ע��dst��src��ά���뱣��һ��
% dst src ����3ά����1,2ά��ʾλ�ã�3ά����Ҫ����Ĺ�ϵֵ
% RelatDiff����һ��2ά���󣬱�ʾ�����
[m,n,t]=size(dst);
RelatDiff=zeros(m,n);%ԭͼ��ӡˢͼ�Ĺ�ϵ
temp(:,:,1:t)=xor(dst(:,:,1:t),src(:,:,1:t));%�����ϵ�������
for x=1:m
    for y=1:n   
        RelatDiff(x,y)=sum(temp(x,y,1:t));%������߲���Խ�����ֵԽ��
    end
end

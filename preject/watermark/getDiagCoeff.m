% -------------------------------------------------------------------------
% �˺���������:���Խ��߷���
% �汾:v1.0
% �༭ʱ��:2016-05-24
% ����:WangMian
% �������:Mtr:���Խ��߷���ľ��� vlen:��С������Ƕ��ˮӡ���ص���������
% ���ز���:V:һά���� p:��Ч��ϵ���ĸ���
% ˵��:�������Ƿ���
% -------------------------------------------------------------------------
function [V,p] = getDiagCoeff(Mtr,vlen)
% �˴�ӦУ������ľ����Ƿ�Ϸ�
[m,n,t] = size(Mtr);
if t > 1
    fprintf(1,'����ľ���Ϊ��ά����,������2ά�ķ���!\r');
    return ;
end
if m ~= n
    fprintf(1,'����ľ����Ƿ���,����������!\r');
end
% ���������洢��Чϵ��������
V = zeros(1,numel(Mtr));
p = 0;
% �Ծ�������ϲ��ֽ��з��ԽǷ���
rowStart = vlen;
while(rowStart <= m)
    i = rowStart;
    j = 1;
    while(i >= 1)
        p = p + 1;
        V(1,p) = Mtr(i,j);
        i = i - 1;
        j = j + 1;
    end
    rowStart = rowStart + 1;
end
% �Ծ�������ϲ��ֽ��з��ԽǷ���
colStart = 2;
while(colStart <= (n - vlen + 1))
    i = m;j = colStart;
    while(j <= n)
        p = p + 1;
        V(1,p) = Mtr(i,j);
        i = i - 1;
        j = j + 1;
    end
    colStart = colStart + 1;
end
V = V(1:p);

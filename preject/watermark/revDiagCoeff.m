% -------------------------------------------------------------------------
% �˺���������:�淴�Խ��߷���
% �汾:v1.0
% �༭ʱ��:2016-05-25
% ����:WangMian
% �������:Mtr:������Խ��߷���ľ��� V:���µĲ���
%         vlen:��С������Ƕ��ˮӡ���ص���������
% ���ز���:newMtr:������Խ��߷���ľ���
% ˵��:�������Ƿ���
% -------------------------------------------------------------------------
function [newMtr] = revDiagCoeff(newMtr,V,vlen)
% �˴�ӦУ������ľ����Ƿ�Ϸ�
[m,n,t] = size(newMtr);
newMtr = newMtr;
if t > 1
    fprintf(1,'����ľ���Ϊ��ά����,������2ά�ķ���!\r');
    return ;
end
if m ~= n
    fprintf(1,'����ľ����Ƿ���,����������!\r');
end
p = 0;
% �Ծ�������ϲ��ֽ��з��ԽǷ���
rowStart = vlen;
while(rowStart <= m)
    i = rowStart;
    j = 1;
    while(i >= 1)
        p = p + 1;
        newMtr(i,j) = V(1,p);
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
        newMtr(i,j) = V(1,p);
        i = i - 1;
        j = j + 1;
    end
    colStart = colStart + 1;
end

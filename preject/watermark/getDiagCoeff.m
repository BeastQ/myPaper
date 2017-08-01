% -------------------------------------------------------------------------
% 此函数的作用:反对角线分组
% 版本:v1.0
% 编辑时间:2016-05-24
% 作者:WangMian
% 传入参数:Mtr:欲对角线分组的矩阵 vlen:最小的用以嵌入水印比特的向量长度
% 返回参数:V:一维向量 p:有效的系数的个数
% 说明:矩阵需是方阵
% -------------------------------------------------------------------------
function [V,p] = getDiagCoeff(Mtr,vlen)
% 此处应校验输入的矩阵是否合法
[m,n,t] = size(Mtr);
if t > 1
    fprintf(1,'输入的矩阵为多维矩阵,请输入2维的方阵!\r');
    return ;
end
if m ~= n
    fprintf(1,'输入的矩阵不是方阵,请重新输入!\r');
end
% 产生用来存储有效系数的向量
V = zeros(1,numel(Mtr));
p = 0;
% 对矩阵的左上部分进行反对角分组
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
% 对矩阵的右上部分进行反对角分组
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

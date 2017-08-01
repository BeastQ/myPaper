function [msg] = giQimDehide_DCT_Glp2(target, delta, minVlen, p, wfLen)
% --------------------------------------------------------------------------------------------------------------
% 此函数的作用:  DiagCoeff方式提取水印
% 版本：v1.0
% 作者：Wangmian
% 最后编辑者：zcr214
% 最后编辑时间：2016-07-05
% 传入参数: 
%               stg:        含有水印的图像的数据方阵;
%               delta:      量化步长;
%               vlen:       向量的长度;
%               p:          范数的阶数
%               wfLen:      水印信息的长度.
% 返回参数 : 
%               o:           提取到的水印信息 (1*n)
% --------------------------------------------------------------------------------------------------------------


si = size(target);
%计算最多能提取多少比特的信息
N = 2*(si(1) - minVlen) + 1;
msg = zeros(1, N);
Dct = dct2(target);

[V,~] = getDiagCoeff(Dct,minVlen);
k = minVlen;
startPosX = 1;
for i = 1:N
    %从向量V中找到第k条对角线所包含的元素,并按对角线分组拆分成两组:vecX,vecY
    if k <= si(1)
        vecLen = floor(k/2);%计算vecX和vecY的长度(所包含的元素个数)
    else
        vecLen = floor((2 * si(1) - k)/2);
    end
    endPosX = startPosX + vecLen - 1;
    if mod(k,2) == 0%如果该对角线是偶数,则将该对角线上的元素对半平分
        startPosY = endPosX + 1;
    else%如果该对角线是奇数,则该对角线中间的元素不属于vecX和vecY(即此元素不被使用)
        startPosY = endPosX + 2;
    end
    endPosY = startPosY + vecLen - 1;
    %vecX = V(startPosX:endPosX);
    %vecY = V(startPosY:endPosY);
    lx=(abs(sum(V(startPosX:endPosX).^p))/vecLen)^(1/p);
    ly=(abs(sum(V(startPosY:endPosY).^p))/vecLen)^(1/p);
    z=lx/ly;
    %for debug.
    if isnan(z)==1 || isinf(z)==1 || (abs(lx)<=1e-6) || (abs(ly)<=1e-6)
        fprintf(1,'HD!i=%d,lx = %f, ly = %f\n',i,lx,ly);
        continue;
    end
    msg(i) = minEucDistance(z, delta); 
    %for debug
    %{
    d = wfD(i);
    if o(i) ~= d
         fprintf(1, '%d dehide error!\n',i);
    end
    %}
    k = k + 1;
    startPosX = endPosY + 1;
    if k > (2 * si(1) - 1)
        printf(1,'第%d条对角线不存在,已超出范围!\r',k);
    end
end
if wfLen<N
    msg=msg(1:wfLen);
else
    %此处是原水印信息的长度大于载体图像所能嵌入的长度，
    %在本程序中，暂时不考虑这种情况
end
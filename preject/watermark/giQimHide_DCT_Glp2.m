function [wmImData] = giQimHide_DCT_Glp2(target, emMsg, delta, minVlen, p, fid)
% ------------------------------------------------------------------------------
% 此函数的作用：DiagCoeff方式嵌入水印
% 版本：v3.0
% 作者： WangMian
% 最后编辑：zcr214
% 最后编辑时间：2016-07-05 
% 传入参数:
%               target: 目标数据方阵
%               emMsg:     要嵌入的水印数据(1*n)
%               delta:     量化步长
%               p:         范数的阶数    
%               fid:       文件句柄 (1 标准输出（屏幕）;2 标准出错输出；其他，输出到指定位置）
% 返回参数：
%               wmImData:  嵌入水印后的目标方阵
% ------------------------------------------------------------------------------

si = size(target);
len = length(emMsg);
%计算最多能嵌入多少比特的信息
N = 2*(si(1) - minVlen) + 1;
if len < N
    emMsg = [emMsg, zeros(1, N - len)];
end
if len > N
    emMsg = emMsg(1:N);
end
%有问题
Dct = dct2(target);

%call function to get vector that will be used to hide information.
[V,~] = getDiagCoeff(Dct,minVlen);
%hiding information.
k = minVlen;
startPosX = 1;
for i = 1:N
    d = emMsg(i);
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
        fprintf(fid,'HD!i=%d,lx = %f, ly = %f\n',i,lx,ly);
        continue;
    end
    %call function to get z1.
    z1 = quantificate(z, d, delta);
    if z1 == 0
        z1 = delta / 8;
    end
    if z1 < 0
        z1=z1+delta;
        fprintf(fid, 'caution\r\n');
        fprintf(fid,'caution\r\n');
    end
    r=sqrt(z1/z);
    %update
    V(startPosX:endPosX) = r * V(startPosX:endPosX);
    V(startPosY:endPosY) = V(startPosY:endPosY)/r;
    k = k + 1;
    startPosX = endPosY + 1;
    if k > (2 * si(1) - 1)
        printf(1,'第%d条对角线不存在,已超出范围!\r',k);
    end
end
%call function to get new dct matrix of image.
Dct = revDiagCoeff(Dct,V,minVlen);
%call idct2 to get new data matrix of image.
o = idct2(Dct);

% o = uint8(o);
wmImData=o;
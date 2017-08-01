function [msg] = giQimDehide_DCT_Glp(target, delta, vlen, p, wfLen)
% --------------------------------------------------------------------------------------------------------------
% 此函数的作用:  ZigZag方式提取水印
% 版本：v1.0
% 作者：Wangmian
% 最后编辑者：zcr214
% 最后编辑时间：2016-07-05
% 传入参数: 
%               target:     含有水印目标的数据方阵;
%               delta:      量化步长;
%               vlen:       向量的长度;
%               p:          范数的阶数
%               wfLen:      水印信息的长度.
% 返回参数 : 
%               Msg:         提取到的水印信息 (1*n)
% --------------------------------------------------------------------------------------------------------------

si = size(target);
%There are si(1) * si(2) coefficents. But DC and high frequence
%coefficients are not to be used. So there are only (si(1) * si(2) -1)/2
%coefficients left. In addition to that, every VLen cofficients are grouped
%into a vector, and every 2 vectors can be embedded 1 bit.
N = floor( (si(1)*si(2)-1) / (2 * 2 * vlen) );
o = zeros(1, N);
Dct = dct2(target);

[~,~,V] = zigzagOrder(si(1),Dct);% Assume Dct is a square matrix.
VE = V(2:N*2*vlen+1);%vector to be embedded
ME = reshape(VE, vlen, 2 * N);%Assert ME is VLen by 2 * N matrix.
oddSeq=rand(1,vlen*N);oddCount=0;
evenSeq=rand(1,vlen*N);evenCount=0;
FE=reshape(ME,1,vlen*2*N);
for i=1:vlen*2*N
    if mod(i,2)==0
        evenCount=evenCount+1;
        evenSeq(evenCount)=FE(i);
    else
        oddCount=oddCount+1;        
        oddSeq(oddCount)=FE(i);
    end
end
evenSeq=reshape(evenSeq,vlen,N);
oddSeq=reshape(oddSeq,vlen,N);
for i = 1:N
    lx=(abs(sum(evenSeq(:,  i).^p))/vlen)^(1/p);
    ly=(abs(sum(oddSeq(:, i).^p))/vlen)^(1/p);
    z=lx/ly;
    %for debug
    if isnan(z)==1 || isinf(z)==1 || (abs(lx)<=1e-6) || (abs(ly)<=1e-6)
        fprintf(1,'DH!i=%d,lx = %f, ly = %f\n',i,lx,ly);
        continue;
    end
    o(i) = minEucDistance(z, delta); 
    %for debug
    %{
    d = wfD(i);
    if o(i) ~= d
         fprintf(1, '%d dehide error!\n',i);
    end
    %}
end
if wfLen<N
    msg=o(1:wfLen);
else
    msg=o;
    %此处是原水印信息的长度大于载体图像所能嵌入的长度，
    %在本程序中，暂时不考虑这种情况
end


function [wmImData] = giQimHide_DCT_Glp(target, emMsg, delta, vlen, p,fid)
% ------------------------------------------------------------------------------
% 此函数的作用：zigzag方式嵌入水印
% 版本：v3.0
% 作者： WangMian
% 最后编辑：zcr214
% 最后编辑时间：2016-07-05 
% 传入参数:
%               target:    目标数据方阵
%               emMsg:     要嵌入的水印数据(1*n)
%               delta:     量化步长
%               p:         范数的阶数
%               fid:       文件句柄 (1 标准输出（屏幕）;2 标准出错输出；其他，输出到指定位置）
% 返回参数：
%               wmImData:  水印图像方阵
% ------------------------------------------------------------------------------

si = size(target);
len = length(emMsg);
%There are si(1) * si(2) coefficents. But DC and high frequence
%coefficients are not to be used. So there are only (si(1) * si(2) -1)/2
%coefficients left. In addition to that, every VLen cofficients are grouped
%into a vector, and every 2 vectors can be embedded 1 bit.
N = floor((si(1)*si(2)-1) / (2 * 2 * vlen) );
if len < N
    emMsg = [emMsg, zeros(1, N - len)];
end
if len > N
    emMsg = emMsg(1:N);
end
Dct = dct2(target);

%call function to get vector that will be used to hide information.
[~,~,V] = zigzagOrder(si(1),Dct);% Assume Dct is a square matrix.
VE = V(2:N*2*vlen+1);%vector to be embedded
ME = reshape(VE, vlen, 2 * N);%Assert ME is VLen by 2 * N matrix.
%divided the vector VE into two subsquences oddSeq and evenSeq
%containing the odd and even indexed terms, repectively: oddSeq(i)=VE(2i-1),
%evenSeq(i)=VE(2i).
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
%reshape the evenSeq and oddSeq by VLen*N.
evenSeq=reshape(evenSeq,vlen,N);
oddSeq=reshape(oddSeq,vlen,N);
%hiding information.
for i = 1:N
    d = emMsg(i);
    %calculate the lp-norm of evenSeq and oddSeq.
    lx=(abs(sum(evenSeq(:,  i).^p))/vlen)^(1/p);
    ly=(abs(sum(oddSeq(:, i).^p))/vlen)^(1/p);
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
    k=sqrt(z1/z);
    evenSeq(:, i)= k * evenSeq(:, i);
    oddSeq(:, i)=oddSeq(:, i)/k;
end
%update VE.
oddP=1;evenP=1;
MeRow=0;MeCol=1;
oddSeq=reshape(oddSeq,1,oddCount);
evenSeq=reshape(evenSeq,1,evenCount);
for i=1:vlen*2*N
    if mod(i,2)==1
        temp=oddSeq(oddP);
        oddP=oddP+1;
    else
        temp=evenSeq(evenP);
        evenP=evenP+1;
    end
    if MeRow<vlen
        MeRow=MeRow+1;
    else
        MeRow=1;
        MeCol=MeCol+1;
    end
    ME(MeRow,MeCol)=temp;
end
VE = reshape(ME,vlen * 2 * N, 1);
V(2:N*2*vlen+1) = VE;
%call function to get new dct matrix of image.
Dct = izigzagOrder(si(1),V);
%call idct2 to get new data matrix of image.
o = idct2(Dct);

% o = uint8(o);
wmImData=o;
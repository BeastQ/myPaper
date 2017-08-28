function [wmImData] = giQimHide_DCT_Glp2(target, emMsg, delta, minVlen, p, fid)
% ------------------------------------------------------------------------------
% �˺��������ã�DiagCoeff��ʽǶ��ˮӡ
% �汾��v3.0
% ���ߣ� WangMian
% ���༭��zcr214
% ���༭ʱ�䣺2016-07-05 
% �������:
%               target: Ŀ�����ݷ���
%               emMsg:     ҪǶ���ˮӡ����(1*n)
%               delta:     ��������
%               p:         �����Ľ���    
%               fid:       �ļ���� (1 ��׼�������Ļ��;2 ��׼��������������������ָ��λ�ã�
% ���ز�����
%               wmImData:  Ƕ��ˮӡ���Ŀ�귽��
% ------------------------------------------------------------------------------

si = size(target);
len = length(emMsg);
%���������Ƕ����ٱ��ص���Ϣ
N = 2*(si(1) - minVlen) + 1;
if len < N
    emMsg = [emMsg, zeros(1, N - len)];
end
if len > N
    emMsg = emMsg(1:N);
end
%������
Dct = dct2(target);

%call function to get vector that will be used to hide information.
[V,~] = getDiagCoeff(Dct,minVlen);
%hiding information.
k = minVlen;
startPosX = 1;
for i = 1:N
    d = emMsg(i);
    %������V���ҵ���k���Խ�����������Ԫ��,�����Խ��߷����ֳ�����:vecX,vecY
    if k <= si(1)
        vecLen = floor(k/2);%����vecX��vecY�ĳ���(��������Ԫ�ظ���)
    else
        vecLen = floor((2 * si(1) - k)/2);
    end
    endPosX = startPosX + vecLen - 1;
    if mod(k,2) == 0%����öԽ�����ż��,�򽫸öԽ����ϵ�Ԫ�ض԰�ƽ��
        startPosY = endPosX + 1;
    else%����öԽ���������,��öԽ����м��Ԫ�ز�����vecX��vecY(����Ԫ�ز���ʹ��)
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
        printf(1,'��%d���Խ��߲�����,�ѳ�����Χ!\r',k);
    end
end
%call function to get new dct matrix of image.
Dct = revDiagCoeff(Dct,V,minVlen);
%call idct2 to get new data matrix of image.
o = idct2(Dct);

% o = uint8(o);
wmImData=o;
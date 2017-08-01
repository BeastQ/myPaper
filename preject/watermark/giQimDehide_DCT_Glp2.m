function [msg] = giQimDehide_DCT_Glp2(target, delta, minVlen, p, wfLen)
% --------------------------------------------------------------------------------------------------------------
% �˺���������:  DiagCoeff��ʽ��ȡˮӡ
% �汾��v1.0
% ���ߣ�Wangmian
% ���༭�ߣ�zcr214
% ���༭ʱ�䣺2016-07-05
% �������: 
%               stg:        ����ˮӡ��ͼ������ݷ���;
%               delta:      ��������;
%               vlen:       �����ĳ���;
%               p:          �����Ľ���
%               wfLen:      ˮӡ��Ϣ�ĳ���.
% ���ز��� : 
%               o:           ��ȡ����ˮӡ��Ϣ (1*n)
% --------------------------------------------------------------------------------------------------------------


si = size(target);
%�����������ȡ���ٱ��ص���Ϣ
N = 2*(si(1) - minVlen) + 1;
msg = zeros(1, N);
Dct = dct2(target);

[V,~] = getDiagCoeff(Dct,minVlen);
k = minVlen;
startPosX = 1;
for i = 1:N
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
        printf(1,'��%d���Խ��߲�����,�ѳ�����Χ!\r',k);
    end
end
if wfLen<N
    msg=msg(1:wfLen);
else
    %�˴���ԭˮӡ��Ϣ�ĳ��ȴ�������ͼ������Ƕ��ĳ��ȣ�
    %�ڱ������У���ʱ�������������
end
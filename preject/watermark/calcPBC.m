% --------------------------------------------------------------------------------------------------------------
% �˺���������: �����ֵ�����psnr,������ber,����ϵ��corr,��ȡ����ˮӡ��Ϣ��Ƕ��(ԭʼ)��ˮӡ��Ϣ�Ĳ���ͬ����Ŀcount
% �汾:         v1.0
% �༭ʱ��:     2016-07-07
% ����:         WangMian
% ���༭��    zcr214
% �������:     wmImData: ˮӡͼ�� dtImData: ������ͼ�� bitDepth: ͼ��ÿͨ����λ���
%               emMsg: Ƕ���ˮӡ���� exMsg: ��ȡ����ˮӡ���� msgLen: ˮӡ���ݵĳ���
% ���ز���:     psnr: ��ֵ����� ber:������ corr: ����ϵ�� count:��ȡ����ˮӡ��Ϣ��Ƕ��(ԭʼ)��ˮӡ��Ϣ�Ĳ���ͬ����Ŀ
% --------------------------------------------------------------------------------------------------------------              
function [psnr,ber,corr,count] = calcPBC(wmImData,dtImData,bitdepth,emMsg,exMsg)
psnr = getPsnr(wmImData,dtImData,bitdepth);
ber = getBer(emMsg, exMsg);
corr = getCorr(emMsg, exMsg);
count =getDiffcount(emMsg,exMsg);


% --------------------------------------------------------------------------------------------------------------
% �˺���������: ������ȡˮӡ��������,���õ�ͼ��ģʽΪRGB(ˮӡ��Դ��ָ���ļ�)
% �汾:         v1.1.1
% �༭ʱ��:     2016-06-14
% ����:         WangMian
% ˵��:         �����д�Ƕ��ˮӡ������ǰ,����ȷ�ϻ������������ز���;
%               ������Լ���ʵ��Ҫ���޸Ĳ�����������
% ------------------------------------------------------------------------------
clear all;close all;clc;

%  dtImFormat='.jpg';%ͼƬ��ʽ
 dtImFormat='.tif';%ͼƬ��ʽ
%  
vConType = 'ZigZag';         %ʸ���Ĺ��ɷ�ʽ:ZigZag:zigzagɨ�� DiagCoeff:���Խ��߷���
% msgType = 'msgFromOrgImage';         
slipExtract_LAB_wavelet(vConType,dtImFormat,'CMYK',0.33);
slipExtract_LAB_wavelet(vConType,dtImFormat,'CMYK',0.7);

vConType = 'DiagCoeff'; 
slipExtract_LAB_wavelet(vConType,dtImFormat,'CMYK',0.33);
slipExtract_LAB_wavelet(vConType,dtImFormat,'CMYK',0.7);

% vConType = 'ZigZag';         %ʸ���Ĺ��ɷ�ʽ:ZigZag:zigzagɨ�� DiagCoeff:���Խ��߷���
% msgType = 'msgFromOrgImage';         
% slipExtract(vConType,msgType,dtImFormat,'CMYK');
% 
% vConType = 'DiagCoeff'; 
% slipExtract(vConType,msgType,dtImFormat,'CMYK');
%%-------------------------------------------------------------------------------
% vConType = 'ZigZag';         %ʸ���Ĺ��ɷ�ʽ:ZigZag:zigzagɨ�� DiagCoeff:���Խ��߷���
% 
% msgType = 'msgFromOrgImage';          %ˮӡ��Ϣ��Դ:allOnes:ȫ1 allZeros:ȫ0 alternate:01���� random:01��� msgFromOrgImage:��Դ������
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
%  msgType='allZeros';
%  slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='allOnes';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='alternate';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
%  
%  msgType='random';
%  slipExtract(vConType,msgType,dtImFormat,'RGB');
% %-------------------------------------------------------------------------------
% %-------------------------------------------------------------------------------
% vConType = 'DiagCoeff';         %ʸ���Ĺ��ɷ�ʽ:ZigZag:zigzagɨ�� DiagCoeff:���Խ��߷���
% 
% msgType = 'msgFromOrgImage';          %ˮӡ��Ϣ��Դ:allOnes:ȫ1 allZeros:ȫ0 alternate:01���� random:01��� msgFromOrgImage:��Դ������
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='allZeros';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='allOnes';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='alternate';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% 
% msgType='random';
% slipExtract(vConType,msgType,dtImFormat,'RGB');
% %-------------------------------------------------------------------------------
% 

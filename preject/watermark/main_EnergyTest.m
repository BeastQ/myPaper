clear all;close all;clc;
%-------------------------------------------------------------------------------
%����ͼ��ˮӡ���������
% ImgPath='detectImage\RGB\';
% xlsPath='detectImage\RGB\best.xlsx';
ImgPath='detectImage\CMYK\';
xlsPath='detectImage\CMYK\best.xlsx';
% sidelen=450;%������580��С��ͼ�����ͺ�ͼ��ˮӡ����Ϊ450*450
% sidelen=350;%ʹ����490*490�ĺ�ɫlogoͼ,ˮӡ����Ϊ350*350
% sidelen=128;%ʹ����171*171�ĺ�logoͼ,ˮӡ����Ϊ128*128
sidelen=160;%ʹ����210*210�ĺ�ɫ�Ʊ�ͼ��ˮӡ����Ϊ160*160
% sidelen=512;%ʹ����567*567�Ļ���ͼ,ˮӡ����Ϊ512*512

% saveWmArea(ImgPath,xlsPath,'RGB',sidelen);%����ˮӡ�����RGBͼ��mat�ļ�
%  saveWmArea(ImgPath,xlsPath,'CMYK',sidelen);%����ˮӡ�����CMYKͼ��ת��ΪLAB��mat�ļ�
%   wmAreaTest(ImgPath,'PartialMeanEnergy');%�������������ֵ
%  wmAreaTest(ImgPath,'DCT_Signature');% ��DCTϵ����������������ֵ
%    wmAreaTest(ImgPath,'save_DCT_Relation_RGB');% ��ȡ������ DCTϵ����ϵ
%  wmAreaTest(ImgPath, 'save_DCT_Relation_CMYK');% ��ȡ������ DCTϵ����ϵ
%    wmAreaTest(ImgPath,'show_DCT_Relation_RGB');% �Ƚϸ���DCTϵ����ϵ��ͳ��ԭͼ��ӡˢͼ����ӡͼ��PS�ٴ���ͼ�Ĳ���ȣ�����ͼչʾ
 wmAreaTest(ImgPath,'show_DCT_Relation_CMYK');% �Ƚϸ���DCTϵ����ϵ��ͳ��ԭͼ��ӡˢͼ����ӡͼ��PS�ٴ���ͼ�Ĳ���ȣ�����ͼչʾ

% wmAreaTest(ImgPath,'PatchworkTest');% ��ȡ������ DCTϵ����ϵ
fprintf(1,'���н���');
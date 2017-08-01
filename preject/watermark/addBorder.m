% -------------------------------------------------------------------------
% �˺���������: ��ͼ��Ӻڱ߿�(���ڴ�ӡ��ü�)��������ͬһ�ļ�����
% version:      v1.0
% edit time:    2016-05-18
% author:       WangMian
% �������:     imData:Ҫ�ӱ߿��ͼ�� imPattern:ͼ���ģʽ(CMYK,LAB,RGB,GRAY)
%               d:Ҫ�ӵı߿�Ŀ��(������Ϊ��λ)
% ���ز���:     imDataBorder:�Ѽӿ��Ϊd�ı߿��ͼ��
% ˵��:         �˰汾��matlab(2012a)��CMYKģʽֻ֧��TIF��ʽ��ͼ��;
%               ��RGBģʽ��GRAYģʽ֧��BMP,JPG,TIF��ʽ��ͼ��;
% -------------------------------------------------------------------------
function [imDataBorder] = addBorder(imData,imPattern,d)
% �涨Ҫ�ӵı߿����ɫ(Ĭ��Ϊ��ɫ)
rgbBorder = [0,0,0];%��ɫ��RGBֵ
cmykBorder = [0,0,0,255];%��ɫ��CMYKֵ
grayBorder = 0;%��ɫ�ĻҶ�ֵ
% ��ͼ���ָ����ɫ�ı߿�
[m,n,t] = size(imData);
imDataBorder = uint8(zeros(m+d*2,n+d*2,t));
for i = 1:t
    if strcmp(imPattern,'CMYK')%CMYKģʽ
        imDataBorder(:,:,i) = cmykBorder(i);
    elseif strcmp(imPattern,'RGB')%RGBģʽ
        imDataBorder(:,:,i) = rgbBorder(i);
    else%GRAYģʽ
        imDataBorder(:,:,i) = grayBorder;
    end
    imDataBorder(d+1:m+d,d+1:n+d,i) = imData(:,:,i);
end


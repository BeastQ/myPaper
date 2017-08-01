% -------------------------------------------------------------------------
% �˺���������:��ͼ���·����ͼ��Ӻڱ߿�(���ڴ�ӡ��ü�)��������ͬһ�ļ�����
% version:      v1.0
% edit time:    2016-05-18
% author:       WangMian
% �������:     imPath:��Ҫ�Ӻڱߵ�ͼ�������ļ���·�� imName:ͼ������� 
%               imFormat:ͼ��ĸ�ʽ d:�ӵı߿�Ŀ��(������Ϊ��λ)
% ˵��:         �˰汾��matlab(2012a)��CMYKģʽֻ֧��TIF��ʽ��ͼ��;
%               ��RGBģʽ��GRAYģʽ֧��BMP,JPG,TIF��ʽ��ͼ��;
% -------------------------------------------------------------------------
function addBorderByImPath(imPath,imName,imFormat,d)
% �涨Ҫ�ӵı߿����ɫ(Ĭ��Ϊ��ɫ)
rgbBorder = [0,0,0];%��ɫ��RGBֵ
cmykBorder = [0,0,0,100];%��ɫ��CMYKֵ
grayBorder = 0;%��ɫ�ĻҶ�ֵ
% ���ͼ���Ƿ���TIF��BMP��JPG��ʽ
if ~(strcmp(imFormat,'.tif')||strcmp(imFormat,'.bmp')||strcmp(imFormat,'.jpg'))
    fprintf(1,'ѡ���Ҫ�Ӻڱ߿��ͼ��ĸ�ʽΪ: %s,����Ŀǰ��֧��,��ѡ��TIF��BMP��JPG��ʽ��ͼ��!\r',imFormat); 
    return ;
end
% ��ͼ���ָ����ɫ�ı߿�
imInfo = imfinfo(strcat(imPath,imName,imFormat));
imData = imread(strcat(imPath,imName,imFormat));
[m,n,t] = size(imData);
imDataNew = uint8(zeros(m+d*2,n+d*2,t));
for i = 1:t
    if strcmp(imInfo.ColorType,'CMYK')%CMYKģʽ
        imDataNew(:,:,i) = cmykBorder(i);
    elseif strcmp(imInfo.ColorType,'truecolor')%RGBģʽ
        imDataNew(:,:,i) = rgbBorder(i);
    else%GRAYģʽ
        imDataNew(:,:,i) = grayBorder;
    end
    imDataNew(d+1:m+d,d+1:n+d,i) = imData(:,:,i);
end
% ����ͼ��ͬһ�ļ�����,������Ϊ imName_c.imFormat.
if strcmp(imInfo.Format,'tif')
    if strcmp(imInfo.Compression,'Uncompressed')%��ѹ��
        compression = 'none';
    else%����ѹ��,��Ҫ��LZW,JPEG,DEFLATE��
        compression = lower(imInfo.Compression);
    end
    imwrite(imDataNew,strcat(imPath,imName,'_c.tif'),'Compression',compression,...
        'Resolution',imInfo.XResolution);%д���ļ�
elseif strcmp(imInfo.Format,'jpg')
    imwrite(imDataNew,strcat(imPath,imName,'_c.jpg'),'quality',100);
elseif strcmp(imInfo.Format,'bmp')
    imwrite(imDataNew,strcat(imPath,imName,'_c.bmp'));
else%�쳣��ʽ�Ĵ���
    fprintf(1,'ѡ���Ҫ�Ӻڱ߿��ͼ��ĸ�ʽΪ: %s,����Ŀǰ��֧��,��ѡ��TIF��BMP��JPG��ʽ��ͼ��!\r',imInfo.Format);
end

% -------------------------------------------------------------------------
% 此函数的作用:按图像的路径给图像加黑边框(便于打印后裁剪)并保存在同一文件夹下
% version:      v1.0
% edit time:    2016-05-18
% author:       WangMian
% 传入参数:     imPath:需要加黑边的图像所在文件夹路径 imName:图像的名称 
%               imFormat:图像的格式 d:加的边框的宽度(以像素为单位)
% 说明:         此版本的matlab(2012a)对CMYK模式只支持TIF格式的图像;
%               对RGB模式和GRAY模式支持BMP,JPG,TIF格式的图像;
% -------------------------------------------------------------------------
function addBorderByImPath(imPath,imName,imFormat,d)
% 规定要加的边框的颜色(默认为黑色)
rgbBorder = [0,0,0];%黑色的RGB值
cmykBorder = [0,0,0,100];%黑色的CMYK值
grayBorder = 0;%黑色的灰度值
% 检测图像是否是TIF、BMP或JPG格式
if ~(strcmp(imFormat,'.tif')||strcmp(imFormat,'.bmp')||strcmp(imFormat,'.jpg'))
    fprintf(1,'选择的要加黑边框的图像的格式为: %s,程序目前不支持,请选择TIF、BMP、JPG格式的图像!\r',imFormat); 
    return ;
end
% 对图像加指定颜色的边框
imInfo = imfinfo(strcat(imPath,imName,imFormat));
imData = imread(strcat(imPath,imName,imFormat));
[m,n,t] = size(imData);
imDataNew = uint8(zeros(m+d*2,n+d*2,t));
for i = 1:t
    if strcmp(imInfo.ColorType,'CMYK')%CMYK模式
        imDataNew(:,:,i) = cmykBorder(i);
    elseif strcmp(imInfo.ColorType,'truecolor')%RGB模式
        imDataNew(:,:,i) = rgbBorder(i);
    else%GRAY模式
        imDataNew(:,:,i) = grayBorder;
    end
    imDataNew(d+1:m+d,d+1:n+d,i) = imData(:,:,i);
end
% 保存图像到同一文件夹下,并命名为 imName_c.imFormat.
if strcmp(imInfo.Format,'tif')
    if strcmp(imInfo.Compression,'Uncompressed')%无压缩
        compression = 'none';
    else%其他压缩,主要有LZW,JPEG,DEFLATE等
        compression = lower(imInfo.Compression);
    end
    imwrite(imDataNew,strcat(imPath,imName,'_c.tif'),'Compression',compression,...
        'Resolution',imInfo.XResolution);%写入文件
elseif strcmp(imInfo.Format,'jpg')
    imwrite(imDataNew,strcat(imPath,imName,'_c.jpg'),'quality',100);
elseif strcmp(imInfo.Format,'bmp')
    imwrite(imDataNew,strcat(imPath,imName,'_c.bmp'));
else%异常格式的处理
    fprintf(1,'选择的要加黑边框的图像的格式为: %s,程序目前不支持,请选择TIF、BMP、JPG格式的图像!\r',imInfo.Format);
end

function saveWmArea(ImgPath,xlsPath,colorSpace,sidelen)
%保存水印区域的RGB图像到mat文件
[position,filename]=xlsread(xlsPath);
%读取文件名和水印在载体的位置信息
if strcmp(colorSpace,'RGB')
    for i=1:length(filename)
        I=imread([ImgPath,filename{i,1},filename{i,2}]);
        wmArea=I(position(i,1):position(i,1)+sidelen-1,position(i,2):position(i,2)+sidelen-1,:);
        save([ImgPath,filename{i,1},'.mat'],'wmArea');
    end;
end;

if strcmp(colorSpace,'CMYK')
    for i=1:length(filename)
        I=imread([ImgPath,filename{i,1},filename{i,2}]);
          % CMYK --> Lab
    cform1 = makecform('cmyk2srgb'); % cmyk转srgb
    rgb = applycform(I,cform1);
    cform2 = makecform('srgb2lab'); % srgb转lab
    I = applycform(rgb,cform2); 
    
        wmArea=I(position(i,1):position(i,1)+sidelen-1,position(i,2):position(i,2)+sidelen-1,:);
        save([ImgPath,filename{i,1},'.mat'],'wmArea');
    end;
end;
function [imDataNew] = cmyk2rgb(imData)
cform = makecform('cmyk2srgb');
imDataNew = applycform(imData,cform);

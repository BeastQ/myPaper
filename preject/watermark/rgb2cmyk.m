function [imDataNew] = rgb2cmyk(imData)
cform = makecform('srgb2cmyk');
imDataNew = applycform(imData,cform);

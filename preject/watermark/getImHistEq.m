function [imHistEq] = getImHistEq(imData)
[~,~,t] = size(imData);
imHistEq = imData;
for i = 1:t
    imHistEq(:,:,i) = histeq(imData(:,:,i));
end
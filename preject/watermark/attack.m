% --------------------------------------------------------------------------------------------------------------
% 此函数的作用：对图像(含水印或者不含水印)进行某种类型的攻击
% 版本:v1.0
% 最后编辑者：WangMian
% 最后编辑时间：2016-03-25 15:51
% 传入参数: 
%                stg:          图像矩阵;
%                type:        攻击类型.
% 返回参数:
%                ss: 被攻击后图像矩阵.
% --------------------------------------------------------------------------------------------------------------
function [ss] = attack(stg, type)
switch type
    case 'no_attack' %无攻击
    ss=stg;
    case 'resize2' %缩放攻击
    ss = imresize(stg, 2, 'bicubic');
    ss = imresize(ss, 1/2, 'bicubic');
    case 'resize2.5'
    ss = imresize(stg, 5/2, 'bicubic');
    ss = imresize(ss, 2/5, 'bicubic');
    case 'resize4'
    ss = imresize(stg, 4, 'bicubic');
    ss = imresize(ss, 1/4, 'bicubic');
    case 'resize.5'
    ss = imresize(stg, 1/2, 'bicubic');
    ss = imresize(ss, 2, 'bicubic');
    case 'resize.25'
    ss = imresize(stg, 1/4, 'bicubic');
    ss = imresize(ss, 4, 'bicubic');
    case 'noise-salt&pepper' %椒盐攻击
    ss = imnoise(stg, 'salt & pepper', 0.001); % density:0.001
    case 'noise-poisson' %泊松攻击
    ss = imnoise(stg, 'poisson');
    case 'filter-med' %中值滤波攻击
    ss = medfilt2(stg);%default:3*3
    case 'crop-center'%中心剪切攻击
    sz = size(stg);
    top = round(sz(1)/4 + 1);
    left = round(sz(2)/4 + 1);
    ss = stg(top + 1: sz(1) - top, left + 1 : sz(2) - left);
    otherwise
        if strfind(type, 'jpeg') %JPEG压缩攻击
            s = regexp(type, '_', 'split');
            q = str2num(s{2}); %#ok<ST2NM>
            imwrite(stg, 't.jpg', 'Quality', q);
            ss = imread('t.jpg');
            delte t.jpg;
        elseif strfind(type,'noise-gaussian') %高斯噪声攻击
            s = regexp(type, '_', 'split');
            d = str2num(s{2}); %#ok<ST2NM>
            ss = imnoise(stg, 'gaussian', 0, 10^(-d/10)); % mean:0, variance:0.001
        end
end
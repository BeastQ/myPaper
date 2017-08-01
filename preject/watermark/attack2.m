%版本:v1.1
%最后编辑者：WangMian
%最后编辑时间：2016-03-25 15:51
%此函数的作用：对图像(含水印或者不含水印)进行某种类型的攻击
%传入参数: 
%                stg:          图像矩阵;
%                type:        攻击类型.
%返回参数:
%                ss: 被攻击后图像矩阵.
function [ss] = attack2(stg, type)
switch type
    case 'no_attack'
        ss=stg;
    case 'histeq'
        si = size(stg);
        ss = stg;
        for i = 1:si(3)
            ss(:,:,i) = stg(:,:,i);
        end
    case 'noise-wiener'
        si = size(stg);
        ss = stg;
        for i = 1:si(3)
            ss(:,:,i) = wiener2(stg(:,:,i),[3 3]);
        end
    case 'scal'
        ss = im2uint8(mat2gray(stg));
    % 半色调处理
    case 'dither'
        [x,map] = rgb2ind(stg,8,'nodither');
        ss = ind2rgb (x,map);    
    case 'resize2'
        ss = imresize(stg, 2, 'bicubic');
        ss = imresize(ss, 1/2, 'bicubic');
    case 'resize4'
        ss = imresize(stg, 4, 'bicubic');
        ss = imresize(ss, 1/4, 'bicubic');
    case 'resize.5'
        ss = imresize(stg, 1/2, 'bicubic');
        ss = imresize(ss, 2, 'bicubic');
    case 'resize.25'
        ss = imresize(stg, 1/4, 'bicubic');
        ss = imresize(ss, 4, 'bicubic');
    case 'noise-salt&pepper'
        ss = imnoise(stg, 'salt & pepper', 0.001); % density:0.001
    case 'noise-poisson'
        ss = imnoise(stg, 'poisson');
    case 'filter-med'
        ss = medfilt2(stg);%default:3*3
    case 'crop-center'
        sz = size(stg);
        top = round(sz(1)/4 + 1);
        left = round(sz(2)/4 + 1);
        ss = stg(top + 1: sz(1) - top, left + 1 : sz(2) - left);
    otherwise
        if strfind(type, 'jpeg')
            s = regexp(type, '_', 'split');
            q = str2num(s{2}); %#ok<ST2NM>
            imwrite(stg, 't.jpg', 'Quality', q);
            ss = imread('t.jpg');
        elseif strfind(type,'noise-gaussian')
            s = regexp(type, '_', 'split');
            d = str2num(s{2}); %#ok<ST2NM>
            ss = imnoise(stg, 'gaussian', 0, 10^(-d/10)); % mean:0, variance:0.001
             % 亮度变换，d = gamma
        elseif strfind(type, 'luminance-change')
            s = regexp(type, '_', 'split');
            d = str2num(s{2}); %#ok<ST2NM>
            ss = imadjust(stg,[],[],d);
        elseif strfind(type, 'stable-scal')
             s = regexp(type, '_', 'split');
             d = str2num(s{2}); %#ok<ST2NM>
             ss = stg.*d;
        end
end
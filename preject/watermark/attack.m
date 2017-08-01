% --------------------------------------------------------------------------------------------------------------
% �˺��������ã���ͼ��(��ˮӡ���߲���ˮӡ)����ĳ�����͵Ĺ���
% �汾:v1.0
% ���༭�ߣ�WangMian
% ���༭ʱ�䣺2016-03-25 15:51
% �������: 
%                stg:          ͼ�����;
%                type:        ��������.
% ���ز���:
%                ss: ��������ͼ�����.
% --------------------------------------------------------------------------------------------------------------
function [ss] = attack(stg, type)
switch type
    case 'no_attack' %�޹���
    ss=stg;
    case 'resize2' %���Ź���
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
    case 'noise-salt&pepper' %���ι���
    ss = imnoise(stg, 'salt & pepper', 0.001); % density:0.001
    case 'noise-poisson' %���ɹ���
    ss = imnoise(stg, 'poisson');
    case 'filter-med' %��ֵ�˲�����
    ss = medfilt2(stg);%default:3*3
    case 'crop-center'%���ļ��й���
    sz = size(stg);
    top = round(sz(1)/4 + 1);
    left = round(sz(2)/4 + 1);
    ss = stg(top + 1: sz(1) - top, left + 1 : sz(2) - left);
    otherwise
        if strfind(type, 'jpeg') %JPEGѹ������
            s = regexp(type, '_', 'split');
            q = str2num(s{2}); %#ok<ST2NM>
            imwrite(stg, 't.jpg', 'Quality', q);
            ss = imread('t.jpg');
            delte t.jpg;
        elseif strfind(type,'noise-gaussian') %��˹��������
            s = regexp(type, '_', 'split');
            d = str2num(s{2}); %#ok<ST2NM>
            ss = imnoise(stg, 'gaussian', 0, 10^(-d/10)); % mean:0, variance:0.001
        end
end
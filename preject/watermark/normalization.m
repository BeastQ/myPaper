function normal = normalization(x,kind)
% 输入：
% x:样本数据
% kind ：1表示归一化 或 2表示标准化，默认归一化到[0,1]
% 输出：
% normal：归一化后的数据

if nargin < 2
    kind = 2; % kind = 1 or 2 表示第一类或第二类规范化
end

[m,n]  = size(x);
normal = zeros(m,n);
% 使用最大值进行归一化
if kind == 1
    for i = 1:m
        ma = max( max(x) );
        mi = min( min(x) );
        normal = ( x-mi )./( ma-mi );
    end
end
% 使用均值，标准差进行标准差
if kind == 2
    for i = 1:m
        mea = mean( x(:) );
        va = var( x(:) );
        normal = ( x-mea )/va;
    end
end

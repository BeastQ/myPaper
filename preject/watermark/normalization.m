function normal = normalization(x,kind)
% ���룺
% x:��������
% kind ��1��ʾ��һ�� �� 2��ʾ��׼����Ĭ�Ϲ�һ����[0,1]
% �����
% normal����һ���������

if nargin < 2
    kind = 2; % kind = 1 or 2 ��ʾ��һ���ڶ���淶��
end

[m,n]  = size(x);
normal = zeros(m,n);
% ʹ�����ֵ���й�һ��
if kind == 1
    for i = 1:m
        ma = max( max(x) );
        mi = min( min(x) );
        normal = ( x-mi )./( ma-mi );
    end
end
% ʹ�þ�ֵ����׼����б�׼��
if kind == 2
    for i = 1:m
        mea = mean( x(:) );
        va = var( x(:) );
        normal = ( x-mea )/va;
    end
end

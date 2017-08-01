function ShowBar3ByHeight(target,name)
% 三维柱状图，每个柱状的颜色根据高度不同而变化
% 请确保target是一个二维矩阵
figure;

b=bar3(target);title(name);
colorbar;
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
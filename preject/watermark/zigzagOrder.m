% ----------------------------------------------------------------------------------------------------------------------
% 此函数的作用：   zigzag扫描
% 版本：           v1.0
% 最后整理者：     WangMian
% 最后整理时间：   2016-03-25
% 传入参数：
%                 n:    方阵的阶数.
%                 Mtr:  欲作zigzag扫描的方阵
% 返回参数：
%                 rv:
%                 cv:
%                 vv:   一维向量
% 说明:
% 分析了ZigZag扫描顺序，具有如下特点：
% 1、移动方向有两类，方向以及x，y坐标增量如下：
% Icr1 = [0,1;1,-1;1,0;-1,1];%move:rigthtward, lower left, downward, upper right 
% Icr2 = [1,0;1,-1;0,1;-1,1];%move:downward, lower left, rightward, upper right 
% 2、整个过程可视为两个动作的迭代，即转向和游走。转向：当沿着某次对角线走到尽头，
% 需要调整方向，此时称为转向。游走：沿着某次对角线前进。特点1中的增量，就是这两类
% 移动的方向，即：{转向、游走、转向、游走}
% 3、当遍历了包含对角线在内的上半角像素后，转向和游走的模式变化了。上半角模式为
% Icr1，下半角模式为Icr2。其中，矩阵的阶为奇数和偶数时，起始游走方式又不同。
% 当阶为偶数时，下半角先：右转->右上->下转->左下->右转....
% 当阶为奇数时，下半角先：下转->左下->右转->右上->下转....
% 4、游走的像素个数具有以下特点：上半角，递增，最大增值阶数；下半角，递减，
% 最小减至1
% ----------------------------------------------------------------------------------------------------------------------
function [rv, cv, vv] = zigzagOrder(n, Mtr)
rv = zeros(n * n , 1);
cv = zeros(n * n , 1);
vv = zeros(n * n , 1);

r = 1; c = 1;
k = 1;
rv(k) = r;
cv(k) = c;
vv(k) = Mtr(r, c);

Icr1 = [0,1;1,-1;1,0;-1,1];%move:rigthtward, lower left, downward, upper right 
Icr2 = [1,0;1,-1;0,1;-1,1];%move:downward, lower left, rightward, upper right 
direction = 0;

for i = 2:n
    direction = direction + 1;
    if direction > 4
        direction = 1;
    end
    
    r = r + Icr1(direction, 1); %change direction
    c = c + Icr1(direction, 2); %change direction
    k = k + 1;
    rv(k) = r; cv(k) = c;
    vv(k) = Mtr(r, c);
    
    direction = direction + 1;
    if direction > 4
        direction = 1;
    end
    
    for j = 2:i %walk along
        r = r + Icr1(direction, 1); %change direction
        c = c + Icr1(direction, 2); %change direction
        k = k + 1;
        rv(k) = r; cv(k) = c;
        vv(k) = Mtr(r, c);
    end
    
end

if mod(n, 2) == 0
    direction = 2;
else
    direction = 0;
end
for i = n - 1:-1:1
    
    direction = direction + 1;
    if direction > 4
        direction = 1;
    end
    
    r = r + Icr2(direction, 1); %change direction
    c = c + Icr2(direction, 2); %change direction
    k = k + 1;
    rv(k) = r; cv(k) = c;
    vv(k) = Mtr(r, c);
    
    direction = direction + 1;
    if direction > 4
        direction = 1;
    end
    
    for j = 2:i %walk along
        r = r + Icr1(direction, 1); %change direction
        c = c + Icr1(direction, 2); %change direction
        k = k + 1;
        rv(k) = r; cv(k) = c;
        vv(k) = Mtr(r, c);
    end
end
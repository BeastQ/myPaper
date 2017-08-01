% ---------------------------------------------------------------------------------------------------
% �˺��������ã� zigzag��ɨ��
% �汾��         v1.0
% ��������ߣ�   WangMian
% �������ʱ�䣺 2016-03-25 16:29
% ���������
%               n:      ��Ƶ���־������.
%               V:      ��ˮӡ��������1*n��.
% ���ز�����
%               Mtr:    ��zigzag��ɨ��ĵõ��ķ���
% ������ZigZagɨ��˳�򣬾��������ص㣺
% 1���ƶ����������࣬�����Լ�x��y�����������£�
% Icr1 = [0,1;1,-1;1,0;-1,1];%move:rigthtward, lower left, downward, upper right 
% Icr2 = [1,0;1,-1;0,1;-1,1];%move:downward, lower left, rightward, upper right 
% 2���������̿���Ϊ���������ĵ�������ת������ߡ�ת�򣺵�����ĳ�ζԽ����ߵ���ͷ��
% ��Ҫ�������򣬴�ʱ��Ϊת�����ߣ�����ĳ�ζԽ���ǰ�����ص�1�е�����������������
% �ƶ��ķ��򣬼���{ת�����ߡ�ת������}
% 3���������˰����Խ������ڵ��ϰ�����غ�ת������ߵ�ģʽ�仯�ˡ��ϰ��ģʽΪ
% Icr1���°��ģʽΪIcr2�����У�����Ľ�Ϊ������ż��ʱ����ʼ���߷�ʽ�ֲ�ͬ��
% ����Ϊż��ʱ���°���ȣ���ת->����->��ת->����->��ת....
% ����Ϊ����ʱ���°���ȣ���ת->����->��ת->����->��ת....
% 4�����ߵ����ظ������������ص㣺�ϰ�ǣ������������ֵ�������°�ǣ��ݼ���
% ��С����1
% ---------------------------------------------------------------------------------------------------
function Mtr = izigzagOrder(n, V)

r = 1; c = 1;
k = 1;
Mtr(r, c) = V(k);

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
    Mtr(r, c) = V(k);
    
    direction = direction + 1;
    if direction > 4
        direction = 1;
    end
    
    for j = 2:i %walk along
        r = r + Icr1(direction, 1); %change direction
        c = c + Icr1(direction, 2); %change direction
        k = k + 1;
        Mtr(r, c) = V(k);
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
    Mtr(r, c) = V(k);
    
    direction = direction + 1;
    if direction > 4
        direction = 1;
    end
    
    for j = 2:i %walk along
        r = r + Icr1(direction, 1); %change direction
        c = c + Icr1(direction, 2); %change direction
        k = k + 1;
        Mtr(r, c) = V(k);
    end
end
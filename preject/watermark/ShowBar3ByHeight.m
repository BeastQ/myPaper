function ShowBar3ByHeight(target,name)
% ��ά��״ͼ��ÿ����״����ɫ���ݸ߶Ȳ�ͬ���仯
% ��ȷ��target��һ����ά����
figure;

b=bar3(target);title(name);
colorbar;
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
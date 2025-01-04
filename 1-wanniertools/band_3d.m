% 打开数据文件并读取，跳过第一行

system_id = 'Mn_3Os with SOC';

num_occupied = 1;
filename = 'bulkek_plane.dat';
data = readmatrix(filename,"NumHeaderLines",1);

% 提取第4、5、8、9列数据
k1 = data(:, 4); % 第4列为x轴
k2 = data(:, 5); % 第5列为y轴
k3 = data(:, 6);
z0 = data(:, 7);
z1 = data(:, 8); % num_occupied 第8列作为第一个z轴数据
z2 = data(:, 9); % 第9列作为第二个z轴数据
z3 = data(:, 10);

%%
% nodes_data = readmatrix('Nodes.dat','NumHeaderLines',2);
% 
% nd_k1 = nodes_data(:,6);
% nd_k2 = nodes_data(:,7);
% nd_energy = nodes_data(:, 5);


%%

figure(); % 创建一个新图
hold on; % 保持当前图像

markFace = 1;
markEdge = 1;
% 10:每个点的大小；MarkerFaceAlpha：标记的面颜色透明度； MarkerEdgeAlpha：标记的边框颜色透明度
scatter3(k1, k2, z0, 10, [179, 122, 181]/255 ,'filled', 'DisplayName',"#band "+(num_occupied-1), 'MarkerFaceAlpha', markFace, 'MarkerEdgeAlpha', markEdge);
scatter3(k1, k2, z1, 10, [205, 79, 38]/255, 'filled', 'DisplayName',"#band "+num_occupied, 'MarkerFaceAlpha', markFace, 'MarkerEdgeAlpha', markEdge);
scatter3(k1, k2, z2, 10, [39, 108, 173]/255, 'filled', 'DisplayName',"#band "+(num_occupied+1), 'MarkerFaceAlpha', markFace, 'MarkerEdgeAlpha', markEdge);
scatter3(k1, k2, z3, 10, [255, 128, 0]/255 ,'filled', 'DisplayName',"#band "+(num_occupied+2), 'MarkerFaceAlpha', markFace, 'MarkerEdgeAlpha', markEdge);


% scatter3(nd_k1, nd_k2, nd_energy, [0,0,0],"filled");



hold off;
% % 添加图例
legend();


% 设置坐标轴等比例
% axis equal;  % 确保 x、y、z 轴的比例一致

% 设置坐标轴字体大小
set(gca, 'FontName', 'Times New Roman', 'FontSize', 18);
% 设置坐标轴刻度朝内
set(gca, 'TickDir', 'in');

xlabel('k_1');
ylabel('k_2');
zlabel('Energy (eV)');
title(system_id);

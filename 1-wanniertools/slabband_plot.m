clc;
clear;

data = readmatrix('slabek.dat','NumHeaderLines',1,'FileType','text');

x = data(:,1);
y = data(:,2);

bk = data(:,3);
sl = data(:,4);

weight_diff = sl - bk;

colormap_custom = [0 0 1; 0.5 0.5 0.5; 1 0 0];  % 蓝色 -> 灰色 -> 红色
color_indices = linspace(-1, 1, 256);  % 颜色索引范围
colormap_custom_interp = interp1([-1 0 1], colormap_custom, color_indices, 'linear');

% 创建图形
figure;
hold on;

% 绘制带颜色的点线图
scatter(x, y, 10, weight_diff, 'filled');  % 绘制散点图，颜色由 weight_diff 决定
% plot(x, y, '-k', 'LineWidth', 1);  % 绘制黑色连线

% 设置颜色映射
colormap(colormap_custom_interp);
colorbar;  % 添加颜色条

% 设置坐标轴范围
% xlim([0, 1.47649]);
ylim([-2, 2]);

% 设置 X 轴刻度和标签
% xticks([0, 0.79088, 1.47649]);
% xticklabels({'K', 'G', 'M'});

% 设置 Y 轴标签
ylabel('Energy (eV)');

% 添加垂直线
% line([0.79088, 0.79088], [-7.16531, 23.87730], 'Color', 'k', 'LineWidth', 2, 'LineStyle', '--');

% 图形美化
set(gca, 'FontSize', 14, 'LineWidth', 2);  % 设置坐标轴字体大小和线宽
box on;  % 添加边框
hold off;
%
% --------------------------------------------------------
% grep xtics surfdos_r.gnu 查看高对称路径的位置和名称
% 警告不影响
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;

system_id = 'CaPd_5 Phonon (010) right Surface';
filename = 'dos.dat_r';

data = readmatrix(filename, 'FileType', 'text', 'NumHeaderLines', 1);

% grep xtics surfdos_r.gnu 查看高对称路径的位置和名称
klabel = {'K', 'Γ', 'M'};
kcoors = [0.00000,  0.79088, 1.47649];

kx = data(:,1);
energy = data(:, 2);
dos = data(:, 3);

% 创建网格
[kx_grid, eng_grid] = meshgrid(unique(kx), unique(energy));
dos_grid = griddata(kx, energy, dos, kx_grid, eng_grid, 'cubic');  % 使用 cubic 插值, nearest

%% 

% 创建等高线填充图
figure;

contourf(kx_grid, eng_grid, dos_grid, 100, 'LineColor', 'none');  % 100个等高线等级

% ----------------设置颜色---------------------------
cmap = readmatrix('MPL_bwr.rgb','FileType', 'text','NumHeaderLines', 2);        % MPL_afmhot.rgb  MPL_bwr.rgb  MPL_viridis.rgb
colormap(cmap);
colorbar;  % 显示颜色条
shading interp;  % 平滑显示

% % 设置固定比例
% axis equal;  % 保证 x 和 y 轴的比例相同

% 设置图形属性
xlabel('k_1 (1/Å)', 'fontname', 'times new roman', 'fontsize', 24);
ylabel('Energy (eV)', 'fontname', 'times new roman', 'fontsize', 26);
title(system_id,'fontname', 'times new roman', 'fontsize', 24);

xticks(kcoors);
xticklabels(klabel);
set(gca, 'YGrid', 'off');   % 隐藏纵坐标网格
set(gca, 'XGrid', 'on');
set(gca, 'GridLineStyle', '-');  % 设置为实线
set(gca, 'GridColor', 'k');      % 设置网格颜色为黑色
set(gca, 'GridAlpha', 1);        % 设置网格线的透明度
set(gca, 'FontName', 'Times New Roman', 'FontSize', 24);        % 设置坐标轴字体

set(gca, 'Box', 'on');      % 开启图的边框
set(gca, "Color",[0,0,0],'LineWidth', 1);   % 设置边框粗度为1
set(gca, 'Layer', 'top');   % 把边框图层移到顶层，避免被遮挡

factor = 0.5;
set(gcf, 'Position', [100, 100, 1920*factor, 1680*factor]);  % 设定图像大小
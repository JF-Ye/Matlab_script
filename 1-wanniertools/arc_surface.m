% 作图fermi_arc surface states
clc;
clear;

system_id = 'CaPd_5 Phono (001) right Surface';
filename = 'arc.dat_r';

numhead = 6;     % bulk为 7，l/r 为 6

data = readmatrix(filename, 'FileType', 'text', 'NumHeaderLines', numhead);
kx = data(:,1);
ky = data(:,2);
dos = data(:,3);

% 创建网格
[kx_grid, ky_grid] = meshgrid(unique(kx), unique(ky));
dos_grid = griddata(kx, ky, dos, kx_grid, ky_grid, 'cubic');  % 使用 cubic 插值, nearest错的
%[kx_grid, ky_grid,dos_grid] = griddata(kx, ky, dos, linspace(min(kx),max(kx),800), linspace(min(ky),max(ky),800), 'cubic');  % 使用 cubic 插值, nearest错的

%% 

% 创建3d点图
figure;
% scatter3(kx,ky,dos,'.');
% mesh(kx_grid, ky_grid, dos_grid)
% 
surfc(kx_grid, ky_grid, dos_grid);
shading interp


% ----------------设置颜色---------------------------
cmap = readmatrix('colormap1.rgb','FileType', 'text','NumHeaderLines', 2);        % MPL_afmhot.rgb  MPL_bwr.rgb  MPL_viridis.rgb
colormap(cmap);
colorbar;  % 显示颜色条
shading interp;  % 平滑显示
% axis equal; 


% 创建等高线填充图
figure;
contourf(kx_grid, ky_grid, dos_grid, 100, 'LineColor', 'none');  % 100个等高线等级

% ----------------设置颜色---------------------------
cmap = readmatrix('colormap1.rgb','FileType', 'text','NumHeaderLines', 2);        % MPL_afmhot.rgb  MPL_bwr.rgb  MPL_viridis.rgb
colormap(cmap);
colorbar;  % 显示颜色条
shading interp;  % 平滑显示


% 设置固定比例
axis equal;  % 保证 x 和 y 轴的比例相同

% 设置图形属性
xlabel('k_1 (1/Å)', 'fontname', 'times new roman', 'fontsize', 24);
ylabel('k_2 (1/Å)', 'fontname', 'times new roman', 'fontsize', 24);
title(system_id,'fontname', 'times new roman', 'fontsize', 24);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 24);        % 设置坐标轴字体

set(gca, 'Color', 'w')
set(gca, 'Box', 'on');      % 开启图的边框
set(gca, 'LineWidth', 1);   % 设置边框粗度为1
set(gca, 'Layer', 'top');   % 把边框图层移到顶层，避免被遮挡






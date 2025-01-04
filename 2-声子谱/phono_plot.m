% 声子谱绘图
clc;
clear;

% 绘图的标题
sys_title = 'CaPd_5';
klabels = {'Γ', 'M', 'K', 'Γ', 'A', 'L', 'H'};
file_name = 'phono.dat';


%% 
fid = fopen(file_name,'r');
% 跳过前两行
fgetl(fid);
fgetl(fid);
% 提取kpoints并转为列表
kpoints_str = strtrim(erase(fgetl(fid), '#'));
kpoints = str2double(strsplit(kpoints_str));
fclose(fid);

% 读取剩余数据
opts = detectImportOptions(file_name,"FileType","text",'NumHeaderLines',3,'EmptyLineRule','read');
phono_mat = readmatrix(file_name, opts);

x = phono_mat(:, 1);
y = phono_mat(:, 2);

%% 
figure();
plot(x, y,'Color', [60/255, 126/255, 243/255],'LineWidth',2); 

xticks(kpoints);
xticklabels(klabels);

xlim([kpoints(1), kpoints(end)]);
% ylim([-1, 10]);

ylabel('Frequency (THz)','fontname', 'times new roman', 'fontsize', 24);
title(sys_title,'fontname', 'times new roman', 'fontsize', 24);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 24);        % 设置坐标轴字体


set(gca, 'YGrid', 'off');
set(gca, 'XGrid', 'on');
set(gca, 'GridLineStyle', '--');  % 设置为实线
set(gca, 'GridColor', 'k');      % 设置网格颜色为黑色
set(gca, 'GridAlpha', 1);        % 设置网格线的透明度

set(gca, 'Box', 'on');      % 开启图的边框
set(gca, 'LineWidth', 1);   % 设置边框粗度为1
set(gca, 'Layer', 'top');   % 把边框图层移到顶层，避免被遮挡

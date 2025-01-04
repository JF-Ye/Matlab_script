% 声子线宽Linewidth的绘图
% 需要文件：linewidth.phself.0.075K， capd5.freq.gp(获取x轴坐标)

clc;
clear;

fileLinwd = 'linewidth.phself.0.075K';
filephono = 'capd5.freq.gp';
sys_title = 'CaPd_5';

% 通过freq.gp文件提取x轴数据
phnon_data = readmatrix(filephono,'FileType','text');
x_ori = phnon_data(:, 1);

% 每个高对称点间的k点数
num_points = 200;
klabels = {'Γ', 'M', 'K', 'Γ', 'A'};

lindwidth_data = readmatrix(fileLinwd, 'FileType', 'text', 'NumHeaderLines', 2);

% 提取高对称点x的坐标
high_sym_k = zeros(length(klabels),1);
for i = 1:length(klabels)
    high_sym_k(i,1) = x_ori(1+(i-1)*num_points,1);
end

% lindwidth第二列最后一行  声子谱振动模数
num_modes = lindwidth_data(end, 2);
num_k = (length(klabels) -1) * num_points + 1;   % 每条声子谱上的点的总数
total_points = size(lindwidth_data,1) + num_modes ; % 所有的k点数+空格数

y_freq = zeros(total_points,1);
y_lineWidth = zeros(total_points,1);
x = zeros(total_points,1);

col_now = 1;
for i = 1:num_modes
    new_column = lindwidth_data(i:18:end,3) * 0.242;       % 原单位：meV  ==> 新单位：THz
    y_freq(col_now:num_k+col_now-1,1) = new_column;
    y_freq(col_now+num_k) = NaN;

    new_column = lindwidth_data(i:18:end, 4);
    y_lineWidth(col_now:num_k+col_now-1,1) = new_column;
    y_lineWidth(col_now+num_k) = NaN;

    x(col_now:num_k+col_now-1,1) = x_ori;
    x(col_now+num_k) = NaN;

    col_now = col_now + num_k + 1;
end

% 保存为 lindwidth_plot.dat 文件
total_data = [x, y_freq, y_lineWidth];
fileID = fopen('2-声子谱/lindwidth_plot.dat','w');
fprintf(fileID, '%.4f\t', high_sym_k);
fprintf(fileID, '\n# x\tfrequency\tlinewidth');
fclose(fileID);
writematrix(total_data,'2-声子谱/lindwidth_plot.dat', 'Delimiter', 'tab','WriteMode', 'append');


%%
figure();
plot(x, y_freq, 'color', [70, 70, 70]/255, 'linewidth', 1.5,'DisplayName','Freq_LineWidth');
hold on;


valid_idx = y_lineWidth > 0; % 只保留正值的索引
scatter(x(valid_idx), y_freq(valid_idx), y_lineWidth(valid_idx)*50,  [60/255, 126/255, 243/255], 'filled');
hold off;

xticks(high_sym_k);
xticklabels(klabels);
xlim([0,high_sym_k(end)]);

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














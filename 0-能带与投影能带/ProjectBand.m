% 投影能带图绘制脚本
% 需要文件：PBAND_Mn_SOC.dat， KLABELS
% Jiefeng Ye
clc;
clear;

system_id = 'Mn_3Os (Os orbitals)';

% 能带文件名
bandname = 'PBAND_Os_SOC.dat';
% 跳过前三行说明文字
numHeaderLines = 3;

% 读取数据
data = readmatrix(bandname, 'FileType', 'text', 'NumHeaderLines', numHeaderLines);

% 分解数据
k_path = data(:, 1);      % 第一列: K-PATH
energy = data(:, 2);      % 第二列: 能量
s_proj = data(:, 3);      % 第三列: s 轨道投影
p_proj = data(:, 4);      % 第四列: p 轨道投影
d_proj = data(:, 5);      % 第五列: d 轨道投影



% 读取 KLABELS 文件，跳过第一行和最后一行
filename = 'KLABELS'; % KLABELS 文件名
fileID = fopen(filename, 'r'); % 打开文件
% 跳过第一行说明文字
fgetl(fileID);
% 读取所有数据，直到最后一行（跳过说明文字）
lines = textscan(fileID, '%s %f'); % 读取数据，第一列是标签，第二列是坐标
% 关闭文件
fclose(fileID);
% 删除最后一行（最后一行是文字，不是数据）
lines{1} = lines{1}(1:end-1); % 删除标签中的最后一项
% 提取数据
k_labels = lines{1}; % K 点标签
k_coords = lines{2}; % K 点坐标

%% 


% 绘图设置
figure;

% 确保投影值严格为正（设置最小值以避免错误）
s_valid_id = s_proj >0;
p_valid_id = p_proj >0;
d_valid_id = d_proj >0;

% 设置点大小的比例因子
scal = 30;

% 绘制 s, p, d 投影（蓝色）
scatter(k_path(d_valid_id), energy(d_valid_id), d_proj(d_valid_id) * scal, 'b', 'filled','DisplayName','d orbital', 'MarkerFaceAlpha', 0.6);
hold on;
scatter(k_path(p_valid_id), energy(p_valid_id), p_proj(p_valid_id) * scal, 'g', 'filled','DisplayName','p orbital', 'MarkerFaceAlpha', 0.6);
scatter(k_path(s_valid_id), energy(s_valid_id), s_proj(s_valid_id) * scal, 'r', 'filled','DisplayName','s orbital', 'MarkerFaceAlpha', 0.6);
legend();


% 设置 y 轴范围
ylim([-10, 2]);
xlim([k_coords(1),k_coords(end)]);
% 绘制高对称 K 点并标记
for i = 1:length(k_labels)
    % 使用最近邻查找找到最接近的 K 点坐标
    [~, k_idx] = min(abs(k_path - k_coords(i))); % 查找最接近的坐标位置

    % 在图中添加标签
    text(k_coords(i), energy(k_idx), k_labels{i}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12, 'Color', 'k');
end

% 重新定义横坐标，使其显示正确的 K 点位置
% 假设 k_path 包含连续的 K 点坐标，而 k_coords 是高对称点的坐标
xticks(k_coords);  % 设置横坐标刻度为高对称 K 点的坐标
xticklabels(k_labels);  % 设置横坐标刻度标签为高对称 K 点的标签

% 绘制网格
grid on;

% 添加标签
xlabel('K-PATH');
ylabel('Energy (eV)');
title(system_id);   

hold off;

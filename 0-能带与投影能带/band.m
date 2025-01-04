% 普通能带结构脚本，读取band.dat, KLABELS 作图
% Jiefeng Ye, 2024/11/22
clc;
clear;

system_id = 'Mn_3Os mag1 with SOC';

%% 

%----------读取能带结构的数据--------------%%%%%%%%%%%%%

file_band = 'BAND.dat';

% 读取 num_kp 和 num_band
file_data = fopen(file_band, 'r');
fgetl(file_data);       % 跳过第一行注释
line_2 = fgetl(file_data);
data = sscanf(line_2, '# NKPTS & NBANDS: %d %d');    % 获取K点和能带数
num_kp = data(1);
num_band = data(2);
fclose(file_data);

% 读取klabels
filename = 'KLABELS';                % KLABELS 文件名
fileID = fopen(filename, 'r');       % 打开文件
fgetl(fileID);                       % 跳过第一行说明文字
lines = textscan(fileID, '%s %f');   % 读取数据，第一列是标签，第二列是坐标
fclose(fileID);                      % 关闭文件
lines{1} = lines{1}(1:end-1);        % 删除标签中的最后一项
k_labels = lines{1};                 % K 点标签
k_coords = lines{2};                 % K 点坐标
num_highp = length(k_coords);        % 高对称 K 点个数

% 读取剩余能带数据
banddata = readtable(file_band);        % readtable自动省去 注释行(#) 和 空行

x_tab = banddata(:, 1);
x = table2array(x_tab);
y1_tab = banddata(:, 2);
y1 = table2array(y1_tab);
% 若非共线计算，有spin-up和spin-down
temp = table2array(banddata(3,3));
if isnumeric(temp)
    banddata_array = table2array(banddata);
    for i = 1:size(banddata_array, 1)
        if isnan(banddata_array(i, 1)) && isnan(banddata_array(i, 2))
            banddata_array(i, 3) = NaN;  % 替换第三列为 NaN
        end
    end
    y2 = banddata_array(:, 3);
end

%% 
figure();


if exist("y2")
    plot(x,y1, '-r', 'LineWidth', 1,'DisplayName', 'spin-up');
    hold on;
    plot(x,y2, '-b', 'LineWidth', 1,'DisplayName', 'spin-dw');
    hold off;
    legend('show');
else
    plot(x,y1,'-r', 'LineWidth', 1)
end

% 标记横坐标K点和Klabels
xticks(k_coords);  % 设置横坐标刻度为高对称 K 点的坐标
xticklabels(k_labels);  % 设置横坐标刻度标签为高对称 K 点的标签

ylim([-2 , 2]);
xlim([k_coords(1),k_coords(end)]);
%xlabel('k-point');


ylabel('Energy (eV)','fontname', 'times new roman', 'fontsize', 24);
title(system_id,'fontname', 'times new roman', 'fontsize', 24);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 24);        % 设置坐标轴字体

set(gca, 'YGrid', 'off');   % 隐藏纵坐标网格
y_zero_line = line(xlim, [0 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1,'HandleVisibility','off'); % 费米能级处的虚线
uistack(y_zero_line, 'bottom');     % 使用 uistack 将虚线移到底层
set(gca, 'XGrid', 'on');
set(gca, 'GridLineStyle', '-');  % 设置为实线
set(gca, 'GridColor', 'k');      % 设置网格颜色为黑色
set(gca, 'GridAlpha', 1);        % 设置网格线的透明度

set(gca, 'Box', 'on');      % 开启图的边框
set(gca, 'LineWidth', 1);   % 设置边框粗度为1
set(gca, 'Layer', 'top');   % 把边框图层移到顶层，避免被遮挡




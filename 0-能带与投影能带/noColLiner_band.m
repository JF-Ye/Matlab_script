% 自旋轨道方向投影脚本，生成nocolin_band.dat文件，并作图
% Jiefeng Ye, 2024/11/22
% 需要文件：z.dat, BAND.dat,  KLABELS
clc;
clear;
    
filename = 'x.dat';               



%%
%{}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% ------------提取极化方向的数据-----------%%%%%%%%%%%%%%%%
% 打开并读取数据文件

fid = fopen(filename, 'r');

% 读取第一行，获取 num_kp 和 num_band
header = fgetl(fid);  % 读取第一行
params = sscanf(header, '# %d %d');
num_kp = params(1);   % K 点数量
num_band = params(2); % 能带数量

% 读取剩余的数据
data = fscanf(fid, '%f');  % 读取所有数值数据
fclose(fid);
% 
% 将数据重新排列
plor_matrix = reshape(data, [num_band, num_kp]);  % 转换为以能带为主的排列


%----------读取能带结构的数据--------------%%%%%%%%%%%%%
% 读取 band.dat 文件
file_band = 'BAND.dat';
fid_band = fopen(file_band, 'r');

% 跳过前两行注释
fgetl(fid_band);
fgetl(fid_band);

% 初始化存储变量
KPath = zeros(num_band, num_kp);
Energy = zeros(num_band, num_kp);
band_indices = cell(num_band, 1);

band_idx = 0;
while ~feof(fid_band)
    line = strtrim(fgetl(fid_band));
    if startsWith (line, '#')
        band_idx = band_idx +1;
        band_indices{band_idx} = line;
        k_idx = 1;
        continue;
    elseif isempty(line)
        continue;
    else
        data = sscanf(line, '%f %f');
        KPath(band_idx, k_idx) = data(1);
        Energy(band_idx,k_idx) = data(2);
        k_idx = k_idx + 1;
    end


end

%%%%%%%----------生成nocolin_band.dat文件------%%%%%%%%%%%%
% 一行行展开
kpath_col = reshape(KPath',[],1);
Energy_col = reshape(Energy', [], 1);
plor_col = reshape(plor_matrix', [], 1);

combined_data = [kpath_col, Energy_col, plor_col];

output_file = '0-能带与投影能带/nocolin_band.dat';
fid = fopen(output_file,"w");

fprintf(fid, 'KPATH\tEnergy\tplor_direction\t%d\t%d\n', num_band, num_kp);

for nb = 1:num_band
    fprintf(fid, '# band %d\n', nb);
    for nk = 1:num_kp
        pot = (nb-1)*num_kp + nk;
        fprintf(fid, '%.6f\t%.6f\t%.6f\n', kpath_col(pot), Energy_col(pot), plor_col(pot));     
    end
    fprintf(fid, '\n');
end

fclose(fid);

%}
%% 

clc;
clear;
system_id = 'Mn_3Os with SOC z';     %------------------------------------------------

%{}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%----------------------------作图------------------------%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 读取'nocolin_band.dat'数据
bandname = 'nocolin_band.dat';          
numhead = 2;        % 跳过前2行说明文字
data = readmatrix(bandname, 'NumHeaderLines', numhead); % 读取数据
kpath = data(:, 1);         % 第一列: K-PATH
energy = data(:, 2);        % 第二列: 能量
plor = data(:, 3);          % 第三列: 极化方向


% 读取klabels
filename = 'KLABELS';                % KLABELS 文件名
fileID = fopen(filename, 'r');       % 打开文件
fgetl(fileID);                       % 跳过第一行说明文字
lines = textscan(fileID, '%s %f');   % 读取数据，第一列是标签，第二列是坐标
fclose(fileID);                      % 关闭文件
lines{1} = lines{1}(1:end-1);        % 删除标签中的最后一项
k_labels = lines{1};                 % K 点标签
k_coords = lines{2};                 % K 点坐标


%%% -------------------绘制能带图--------------%%%%%%%%%%%%%%%
figure;

% 设置colormap
cmap = readmatrix('colormap_gray.rgb','FileType', 'text','NumHeaderLines', 2); 
% 绘制散点图
scatter(kpath, energy, 10, plor, 'filled'); % 使用scatter函数绘制散点图，并按plor值着色
colorbar;               % 显示颜色条
% colormap(cmap);  % 设置颜色映射
shading interp;  % 平滑显示


% 标记横坐标K点和Klabels
xticks(k_coords);  % 设置横坐标刻度为高对称 K 点的坐标
xticklabels(k_labels);  % 设置横坐标刻度标签为高对称 K 点的标签

ylim([-2, 2]);
xlim([k_coords(1),k_coords(end)]);
%xlabel('k-point');


ylabel('Energy (eV)','fontname', 'times new roman', 'fontsize', 24);
title(system_id,'fontname', 'times new roman', 'fontsize', 24);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 24);        % 设置坐标轴字体

set(gca, 'YGrid', 'off');   % 隐藏纵坐标网格
y_zero_line = line(xlim, [0 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1); % 费米能级处的虚线
uistack(y_zero_line, 'bottom');     % 使用 uistack 将虚线移到底层
set(gca, 'XGrid', 'on');
set(gca, 'GridLineStyle', '-');  % 设置为实线
set(gca, 'GridColor', 'k');      % 设置网格颜色为黑色
set(gca, 'GridAlpha', 1);        % 设置网格线的透明度

set(gca, 'Box', 'on');      % 开启图的边框
set(gca, 'LineWidth', 1);   % 设置边框粗度为1
set(gca, 'Layer', 'top');   % 把边框图层移到顶层，避免被遮挡
%}

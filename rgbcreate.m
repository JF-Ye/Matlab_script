% 定义渐变关键点的颜色和位置
%{
网址：
https://www.lingdaima.com/jianbianse/
生成HTML代码
background: linear-gradient(90deg, rgba(2,0,36,1) 0%, rgba(136,41,142,1) 4%, rgba(198,62,75,1) 13%, rgba(244,123,20,1) 37%, rgba(251,252,162,1) 100%);
%}

rgbFileName = 'colormap1.rgb';

positions = [0, 0.25, 0.36, 0.50, 1]; % 关键点的位置 (0 到 1 的比例)
colors = [
	2, 0, 36; % rgba(2,0,36,1)
	136, 41, 142; % rgba(136,41,142,1)
	198, 62, 75; % rgba(198,62,75,1)
	244, 123, 20; % rgba(244,123,20,1)
	251, 252, 162 % rgba(251,252,162,1)
] / 255; % 将 RGB 值归一化到 [0,1]

% cmap = [
%     0, 0, 255/255;                       % 蓝色 (0, 0, 255)    
%     180/255, 180/255, 180/255;          % 灰色 (180, 180, 180)
%     255/255, 0, 0                      % 红色 (255, 0, 0)
% ];
% 定义渐变的分辨率
nColors = 256; % 渐变的颜色数量
gradientPositions = linspace(0, 1, nColors);

% 使用线性插值生成渐变颜色
gradientColors = zeros(nColors, 3);
for i = 1:3
    gradientColors(:, i) = interp1(positions, colors(:, i), gradientPositions, 'linear');
end


% 绘制渐变色条
figure;
image(gradientPositions, 1, reshape(gradientColors, [1, nColors, 3]));
axis off;
title('Generated Gradient');



% 将 RGB 值保存到文件

fileID = fopen(rgbFileName, 'w');
fprintf(fileID, 'ncolors= %d\n', nColors);
fprintf(fileID, 'R G B\n');
for i = 1:size(gradientColors, 1)
    fprintf(fileID, '%.6f %.6f %.6f\n', gradientColors(i, :));
end
fclose(fileID);

disp(['RGB 文件已保存到: ', rgbFileName]);
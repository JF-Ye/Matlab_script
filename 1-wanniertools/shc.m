% 读取数据文件
data = load('sigma_shc_eta1.00meV.txt');

x = data(:, 1);
y = data(:, 2);
zx_y = data(:, 17);
xz_y = data(:, 13);

figure;     
plot(x, zx_y, 'b', 'LineWidth', 1.5);
hold on;
plot(x, xz_y, 'r', LineWidth=1.5);
hold off;

% 在 y=0 处添加一条虚线
yline(0, '--k', 'LineWidth', 1.2);  % '--k' 表示黑色虚线，线宽为 1.2

set(gca, 'FontName', 'Times New Roman', 'FontSize', 18);
xlabel('Energy (eV)');
ylabel('SHC (\hbar/e)(\omega·cm)^-1', Interpreter='latex');
title('SHC CaPd_5');
legend('\sigma_{zx^y}', '\sigma_{xz^y}',fontsize=18);

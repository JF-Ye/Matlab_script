% ahc
clc;
clear;

system_id = 'Mn_3Co with SOC';


data = readmatrix('sigma_ahc_eta1.00meV.txt','FileType','text','NumHeaderLines',3);
energy = data(:,1);
sigma_xy = data(:,2);
sigma_yz = data(:,3);
sigma_zx = data(:,4);


%% 
figure;
plot(energy,sigma_zx,'Color', [60/255, 126/255, 243/255],'LineWidth',1.5);
hold on;
plot(energy,sigma_xy,'Color', [236/255, 148/255, 101/255],'LineWidth',1.5);
plot(energy,sigma_yz,'Color', [151/255, 214/255, 148/255],'LineWidth',1.5);


xlabel('Energy (eV)','fontname', 'times new roman', 'fontsize', 24);
ylabel('AHC (S/cm)','fontname',  'times new roman', 'fontsize', 24);


title(system_id,'fontname', 'times new roman', 'fontsize', 24);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 24);        % 设置坐标轴字体
% legend('\sigma_{xy}', '\sigma_{yz}', '\sigma_{zx}',fontsize=18);% 设置图例
legend('zx', 'xy', 'yz', fontsize=18);


xlim([-0.5, 0.5]);
%ylim([-1, 10]);
xticks([-0.5, -0.25, 0, 0.25, 0.5]);

y_zero_line = line(xlim, [0 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1,'HandleVisibility','off'); % 费米能级处的虚线
uistack(y_zero_line, 'bottom');     % 使用 uistack 将虚线移到底层


set(gca, 'Box', 'on');      % 开启图的边框
set(gca, 'LineWidth', 1);   % 设置边框粗度为1
set(gca, 'Layer', 'top');   % 把边框图层移到顶层，避免被遮挡
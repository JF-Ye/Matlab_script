clc;
clear;

finame = 'bulkek.dat';

opts = detectImportOptions(finame, "FileType","text",'NumHeaderLines',3,'EmptyLineRule','read');
data = readmatrix(finame, opts);
x = data(:,1);
energy = data(:,2);
at1 = data(:,3);
at2 = data(:,4);
at3 = data(:,5);
at4 = data(:,6);
at5 = data(:,7);
at6 = data(:,8);


figure

% 确保投影值严格为正（设置最小值以避免错误）
vid1 = at1 >0;
vid2 = at2 >0;
vid3 = at3 >0;
vid4 = at4 >0;
vid5 = at5 >0;
vid6 = at6 >0;

% 设置点大小的比例因子
scal = 30;

scatter(x(vid1), energy(vid1), at1(vid1) * scal, 'b', 'filled','DisplayName','at1', 'MarkerFaceAlpha', 0.6);
hold on;
scatter(x(vid2), energy(vid2), at2(vid2)* scal, 'red', 'filled','DisplayName','at2', 'MarkerFaceAlpha', 0.6);
scatter(x(vid3), energy(vid3), at3(vid3)* scal, 'green', 'filled','DisplayName','at3', 'MarkerFaceAlpha', 0.6);
scatter(x(vid4), energy(vid4), at4(vid4)* scal, 'magenta', 'filled','DisplayName','at4', 'MarkerFaceAlpha', 0.6);
scatter(x(vid5), energy(vid5), at5(vid5)* scal, 'cyan', 'filled','DisplayName','at5', 'MarkerFaceAlpha', 0.6);
scatter(x(vid6), energy(vid6), at6(vid6)* scal, 'yellow', 'filled','DisplayName','at6', 'MarkerFaceAlpha', 0.6);




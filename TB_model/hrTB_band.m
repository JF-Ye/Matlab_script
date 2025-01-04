%%%%%% 数据处理
clc;clear;
efermi=0; %% 费米能级
wannier90_hrdata=importdata('phonopyTB_hr.dat'); 
% textData=wannier90_hrdata.textdata; 
numData=wannier90_hrdata.data;
nbands=numData(1);

% readtable函数作用后POSCAR数据前两行没有提取
POSCAR_latt = [
    5.2910456566302368    0.0000000000000000    0.0000000000000000
    -2.6455228283151184    4.5821799512251014    0.0000000000000000
     0.0000000000000000    0.0000000000000000    4.4405574447903495
     ];

a = POSCAR_latt(1,:);
b = POSCAR_latt(2,:);
c = POSCAR_latt(3,:);

omega=dot(a,cross(b,c));
BZa=2*pi*cross(b,c)/omega;
BZb=2*pi*cross(c,a)/omega;
BZc=2*pi*cross(a,b)/omega;

%%%%%% 沿着高对称路径撒点
%% 高对称点坐标(以倒格子基矢为基)
Gamma0=[0,0,0];
M0=[0.5,0,0];
K0=[1/3,1/3,0];
ktrans=@(x)x(1)*BZa+x(2)*BZb+x(3)*BZc; % 定义匿名函数
Gamma=ktrans(Gamma0);
M=ktrans(M0);
K=ktrans(K0);
kPoints=@(startPoint,endPoint,numPoints)...
    [(linspace(startPoint(1),endPoint(1),numPoints))'...
     (linspace(startPoint(2),endPoint(2),numPoints))'...
     (linspace(startPoint(3),endPoint(3),numPoints))']; % 定义匿名函数
GammaM=kPoints(Gamma,M,51);
MK=kPoints(M,K,31);
KGamma=kPoints(K,Gamma,51);
% 将各段高对称路径上的点拼接，注意接口处重复的点去掉
% 这里拼接之后共101个点
kpoints=[GammaM(1:end-1,:);MK(1:end-1,:);KGamma];
% k路径计算
kpath=zeros(1,length(kpoints));
kpath(1)=0;
for i=2:length(kpoints)
    temp=kpath(i-1);
    kpath(i)=norm(kpoints(i,:)-kpoints(i-1,:))+temp;
end
kk=[kpath(1),kpath(51),kpath(81),kpath(131)]; %% 高对称点位置
labels={'\Gamma','M','K','\Gamma'}; %% 高对称点名称

%%%%%% 求解哈密顿量
Energy=zeros(nbands,length(kpoints));
% parpool; % 启动并行池
for m=1:length(kpoints)
    HH=Hamiltonian(kpoints(m,1),kpoints(m,2),kpoints(m,3));
    % 注意用一下real函数，否则可能有很小的虚部
    vals=sort(real(eig(HH)));
    Energy(:,m)=vals;
end

%%%%%% 画能带图
figure();
for i=1:nbands
    plot(kpath,Energy(i,:)-efermi,'LineWidth',2);
    hold on
end
grid on
hold on
box on
% 设置坐标轴刻度的大小
set(gca, 'FontSize',15);
% 设置线条
xlim([kpath(1) kpath(end)])
xticks(kk)
xticklabels(labels)
%ylim([-1 1])
ylabel('Energy (eV)','FontName','Times New Roman','FontSize',20)
title('Graphene band','FontName','Times New Roman','FontSize',20)
% 设置边框以及长宽比等等
set(gca,'LineWidth',1,'Color',[1 1 1],'XColor',[0.5 0 0.5],'YColor',[0.5 0 0.5],'Layer','top','PlotBoxAspectRatio',[6 5 1])
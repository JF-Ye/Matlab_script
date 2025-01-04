clc;clear;


% 数据处理
efermi=0;                           %%%-------------------------------------------------------
wannier90_hrdata=importdata('phonopyTB_hr.dat'); 

% textData=wannier90_hrdata.textdata; 
numData=wannier90_hrdata.data;
nbands=numData(1);
nhopping=numData(2);
% degeneracy=numData(3:nhopping+2);
numData(1:nhopping+2)=[];
hoppingdata=reshape(numData,7,[])';

POSCAR_latt = [                     %%%-------------------------------------------------------
    5.29104565663102368    0.0000000000000000    0.0000000000000000
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


% 按照跃迁分组
hopping=zeros(1,3,nhopping);
for m=1:nhopping
    hopping(:,:,m)=hoppingdata(1+nbands^2*(m-1),1:3);
end
%hamiltonian=zeros(nbands,nbands,nhopping);
hamiltonian=cell(1,nhopping); % 创建元胞数组
for m=1:nhopping
    temp=zeros(nbands);
    for n=1:nbands^2
        temp(hoppingdata(n+nbands^2*(m-1),4),hoppingdata(n+nbands^2*(m-1),5))=...
        hoppingdata(n+nbands^2*(m-1),6)+1j*hoppingdata(n+nbands^2*(m-1),7);
    end
    hamiltonian{m}=temp;
end
% 定义匿名函数, n为跃迁, k=[kx,ky,kz]为k空间点
%H=@(kx,ky,kz,n) hamiltonian{n}*exp(1j*dot([kx,ky,kz],(hopping(:,1,n)*a+hopping(:,2,n)*b+hopping(:,3,n)*c)));
H=@(k,n) hamiltonian{n}*exp(1j*dot(k,(hopping(:,1,n)*a+hopping(:,2,n)*b+hopping(:,3,n)*c)));




%%
% 沿着高对称路径撒点
% 高对称点坐标(以倒格子基矢为基)
Gamma0=[0,0,0];
M0=[0.5,0,0];
K0=[1/3,1/3,0];
A0=[0,0,0.5];

ktrans=@(x) x(1)*BZa+x(2)*BZb+x(3)*BZc; % 定义匿名函数
Gamma=ktrans(Gamma0);
M=ktrans(M0);
K=ktrans(K0);
A=ktrans(A0);                        %-----------------------------------------------------------------

% 不用改这个匿名函数
kPoints=@(startPoint,endPoint,numPoints)...
    [(linspace(startPoint(1),endPoint(1),numPoints))'...
     (linspace(startPoint(2),endPoint(2),numPoints))'...
     (linspace(startPoint(3),endPoint(3),numPoints))'];     % 定义匿名函数

GammaM=kPoints(Gamma,M,51);
MK=kPoints(M,K,31);
KGamma=kPoints(K,Gamma,51);
GammaA=kPoints(Gamma,A,51);         %-----------------------------------------------------------------

% 将各段高对称路径上的点拼接，注意接口处重复的点去掉
kpoints=[GammaM(1:end-1,:);MK(1:end-1,:);KGamma(1:end-1,:);GammaA]; %---------------------------------

% k路径计算
kpath=zeros(1,length(kpoints));
kpath(1)=0;
for i=2:length(kpoints)
    temp=kpath(i-1);
    kpath(i)=norm(kpoints(i,:)-kpoints(i-1,:))+temp;
end
kk=[kpath(1),kpath(51),kpath(81),kpath(131),kpath(181)]; %% 高对称点位置  %-----------------------------
labels={'\Gamma','M','K','\Gamma','A'}; %% 高对称点名称       %-----------------------------------------


%% 求解哈密顿量
Energy=zeros(nbands,length(kpoints));
% parpool; % 启动并行池
for m=1:length(kpoints)
    HH=zeros(nbands);
    for i=1:nhopping
        %temp=H(kpoints(m,1),kpoints(m,2),kpoints(m,3),i);
        temp=H(kpoints(m,:),i);
        HH=HH+temp;
    end
    
    % 注意用一下real函数，否则可能有很小的虚部
    vals=sort(real(eig(HH)));
    Energy(:,m)=vals;
end

% 画能带图
figure();
for i=1:nbands
    plot(kpath,sqrt(Energy(i,:)-efermi),'LineWidth',2);     %%%%%%%%% 声子谱的本征值要开根号才能对的上，原因不清楚
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

%%

% 沿着倒空间两个基矢撒点,注意为奇数
num=101;
kx0=linspace(-1/2,1/2,num);
ky0=linspace(-1/2,1/2,num);
KPT=zeros(1,3,num,num); % 1,3表示产生1*3的数组,也就是[kx,ky,kz]
for ii=1:num
    kx=kx0(ii);
    for jj=1:num
        ky=ky0(jj);
        % 真实倒空间撒点
        KPT(:,:,ii,jj)=kx*BZa+ky*BZb;
        % 直角倒空间撒点
        %KPT(:,:,ii,jj)=kx*[norm(BZa+BZb),0,0]+ky*[0,norm(BZb),0];  
    end
end
%%
%

% 画示意图
figure();
% 初始化KX,KY,KZ坐标
KX=[];
KY=[];
KZ=[];
for ii=1:num
    for jj=1:num
        KX(end+1)=KPT(:,1,ii,jj);
        KY(end+1)=KPT(:,2,ii,jj);
        KZ(end+1)=KPT(:,3,ii,jj);
    end
end
scatter3(KX,KY,KZ,'filled','c','MarkerFaceAlpha',0.1);
%{
xlabel('KX');
ylabel('KY');
zlabel('KZ');
title('Scatter points in K-space');
axis equal; % 确保轴单位相同
grid on; % 开启网格
hold on;
origin = [0, 0, 0];
b1=BZa;b2=BZb;b3=BZc;
% 绘制向量
quiver3(origin(1), origin(2), origin(3), b1(1), b1(2), b1(3), 0, 'r', 'LineWidth', 2);
quiver3(origin(1), origin(2), origin(3), b2(1), b2(2), b2(3), 0, 'b', 'LineWidth', 2);
quiver3(origin(1), origin(2), origin(3), b3(1), b3(2), b3(3), 0, 'g', 'LineWidth', 2);
% 设置图形属性
grid on;
axis equal;
legend('point', 'b1', 'b2', 'b3');
%}

%%

[E1,E2]=deal(zeros(num,num));
[vecs1,vecs2]=deal(zeros(nbands,1,num,num));

for ii=1:num
    for jj=1:num
        HH=zeros(nbands);
        kpt=KPT(:,:,ii,jj);
        X(ii,jj)=kpt(1);
        Y(ii,jj)=kpt(2);
        Z(ii,jj)=kpt(3);
        for i=1:nhopping
            temp=H(kpt,i);
            HH=HH+temp;
        end
        [vecs,vals]=eig(HH); % 可以同时给出H的本征态和本征值
        [E,I]=sort(real(diag(vals))); % 排序
        E=E-efermi; % matlab给出的本征值是对角矩阵，用diag把对角元素提取出来
        vecs=vecs(:,I);
        
        % 把对应不同kx、ky得到的能量存储起来
        % matlab求出的结果是直接从小到大排好序的，非常方便
        n1=10;n2=11; % 希望计算的能带指标
        E1(ii,jj)=E(n1);
        E2(ii,jj)=E(n2);
        vecs1(:,:,ii,jj)=vecs(:,n1);
        vecs2(:,:,ii,jj)=vecs(:,n2);
    end
end

%%%%%%%%%%%   声子谱的本征值要开根号才能对的上
esq1 = sqrt(E1);
esq2 = sqrt(E2);

cmap = readmatrix('colormap.rgb','FileType', 'text','NumHeaderLines', 2); 


% 3D能带
f2=figure();
hold on
surfc(X,Y,esq1);
surfc(X,Y,esq2);



shading interp
% axis equal;
% 设置图形的方位
view(45,30);
title('3D band structure')
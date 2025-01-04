clear;
efermi=-1.7611; %% 费米能级
poscar=readtable('POSCAR'); %% POSCAR数据文件
wannier90_hrdata=importdata('wannier90_hr.dat'); %% wannier90_hr数据文件

textData=wannier90_hrdata.textdata; % 获取文本数据
numData=wannier90_hrdata.data; % 获取数据矩阵
nbands=numData(1); % wannier90拟合的能带的数目
nhopping=numData(2); % wannier90考虑的跃迁点数目
numData(1:nhopping+2)=[]; % 删除前4行，剩下的数据是跃迁及其矩阵元
hoppingdata=reshape(numData,7,[])'; % 重构数组

% 正格子基矢
a=table2array(poscar(1,:));
b=table2array(poscar(2,:));
c=table2array(poscar(3,:));
% 倒格子基矢
omega=dot(a,cross(b,c));
BZa=2*pi*cross(b,c)/omega;
BZb=2*pi*cross(c,a)/omega;
BZc=2*pi*cross(a,b)/omega;

% 按照跃迁分组
hopping=zeros(1,3,nhopping);
for m=1:nhopping
    hopping(:,:,m)=hoppingdata(1+nbands^2*(m-1),1:3);   % 提取了每个hopping的跃迁方向
end

hamiltonian=zeros(nbands,nbands,nhopping);
for m=1:nhopping
    for n=1:nbands^2
        hamiltonian(hoppingdata(n+nbands^2*(m-1),4),hoppingdata(n+nbands^2*(m-1),5),m)=...
        hoppingdata(n+nbands^2*(m-1),6)+1j*hoppingdata(n+nbands^2*(m-1),7);     
    end
end
%% 高对称点坐标(以倒格子基矢为基)
labels={'\Gamma','M','K','\Gamma'}; %% 高对称点名称
hpoints={[0,0,0],[0.5,0,0],[1/3,1/3,0],[0,0,0]}; %% 高对称点坐标(以倒格子基矢为基)
nk=[41,18,41]; %% 每两个高对称点之间撒点个数

kTrans=@(x)x(1)*BZa+x(2)*BZb+x(3)*BZc; % 定义匿名函数，将高对称点坐标变为直角坐标系下形式
kPoints=@(startPoint,endPoint,numPoints)...
    [(linspace(startPoint(1),endPoint(1),numPoints))'...
     (linspace(startPoint(2),endPoint(2),numPoints))'...
     (linspace(startPoint(3),endPoint(3),numPoints))']; % 定义匿名函数，在高对称点之间均匀撒点
hpoints2=cell(1,length(hpoints));

for i=1:length(hpoints)
    hpoints2(i)={kTrans(hpoints{i})};
end

kpoints=cell(1,length(nk));
kpoints2=[];
for i=1:length(hpoints)-1
    kpoints(i)={kPoints(hpoints2{i},hpoints2{i+1},nk(i))};
    kpoints2=[kpoints2;kpoints{i}(1:end-1,:)];
end
kpoints2=[kpoints2;kTrans(hpoints{end})];
% k路径计算
kpath=zeros(1,length(kpoints2));
kpath(1)=0;

for i=2:length(kpoints2)
    temp=kpath(i-1);
    kpath(i)=norm(kpoints2(i,:)-kpoints2(i-1,:))+temp;
end
kk=zeros(1,4);

for i=1:length(hpoints)
    temp1=[0,0,1:length(nk)-1];
    temp2=[1,cumsum(nk)]-temp1;
    kk(i)=kpath(temp2(i));
end
% 求解哈密顿量
Energy=zeros(nbands,length(kpoints2));
for m=1:length(kpoints2)
    Hamiltonian=zeros(nbands);
    for n=1:nhopping
        temp=hamiltonian(:,:,n)*...
        exp(1j*dot(kpoints2(m,:),(hopping(:,1,n)*a+hopping(:,2,n)*b+hopping(:,3,n)*c)));
        Hamiltonian=Hamiltonian+temp;
    end
    % 注意用一下real函数，否则可能有很小的虚部
    vals=sort(real(eig(Hamiltonian)));
    Energy(:,m)=vals;
end
% 画能带图
figure();
for i=26:27
    plot(kpath,Energy(i,:)-efermi);
    hold on
end
grid on
hold on
box on
%% 设置线条
xlim([kpath(1) kpath(end)])
xticks(kk)
xticklabels(labels)
ylim([-15 15])
ylabel('Energy (eV)')
title('Graphene band')
%% 设置边框以及长宽比等等
set(gca,'LineWidth',0.5,'Color',[1 1 1],'XColor',[0.5 0 0.5],'YColor',[0.5 0 0.5],'Layer','top','PlotBoxAspectRatio',[6 5 1])
print('band_wannier90','-dpng','-r600')
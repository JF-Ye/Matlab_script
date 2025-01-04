clc;clear;
syms M t1 t2 phi kx ky
k=[kx,ky];
a=1;
a1=[0,a];
a2=[-sqrt(3)/2*a,-1/2*a];
a3=[sqrt(3)/2*a,-1/2*a];
b1=a2-a3;
b2=a3-a1;
b3=a1-a2;

dx=t1*(cos(dot(k,a1))+cos(dot(k,a2))+cos(dot(k,a3)));
dy=t1*(sin(dot(k,a1))+sin(dot(k,a2))+sin(dot(k,a3)));
dz=M-2*t2*sin(phi)*(sin(dot(k,b1))+sin(dot(k,b2))+sin(dot(k,b3)));
d=[dx dy dz];

% 计算dx的曲率，norm(d)=sqrt(dx^2 + dy^2 + dz^2)
temp=-1/(4*pi) * dot(cross(diff(d,kx),diff(d,ky)), d) / norm(d)^3;

% 被积函数
f=str2func(['@(M,t1,t2,phi,kx,ky)' vectorize(temp)]);
 

nphi=100;
phi=linspace(-pi,pi,nphi);
nM=100;
M=linspace(-3*sqrt(3),3*sqrt(3),nM);
nc=zeros(nphi);
for ii=1:nM
    for jj=1:nphi
        temp=@(x,y) f(M(ii),4,1,phi(jj),x,y);
        nc(ii,jj)=integral2(temp,-4*sqrt(3)*pi/9,2*sqrt(3)*pi/9,-2*pi/3,2*pi/3);
    end
end

% 绘制密度图
figure();
imagesc(phi,M,nc) % 注意这里nc需要转置才能对应phi,M
colormap(jet) % 定义配色方案，例如使用'jet'配色
colorbar % 显示颜色条
xlabel("$\phi$",'Interpreter','latex')
ylabel("$M/t_2$",'Interpreter','latex')
% 石墨烯能带
clc;clear;
Gamma=[0,0];
M=[pi,pi/sqrt(3)];
K=[2*pi/3,2*sqrt(3)*pi/3];

kn=100; %每段路径k点个数
n=3; % 有几段路径

% Gamma-M段
kx(1:kn)=linspace(0,M(1),100);
ky(1:kn)=linspace(0,M(2),100);
% M-K段
kx(kn+1:2*kn)=linspace(M(1),K(1),100);
ky(kn+1:2*kn)=linspace(M(2),K(2),100);
% K-Gamma段
kx(2*kn+1:3*kn)=linspace(K(1),0,100);
ky(2*kn+1:3*kn)=linspace(K(2),0,100);

for i=1:kn
    vals=eig(hamiltonian(kx(i),ky(i)));
    E1(i)=vals(1);
    E2(i)=vals(2);
    kv=[kx(i),ky(i)];
    k(i)=norm(kv); % 第一段k路径 
    for i=kn+1:2*kn
        vals=eig(hamiltonian(kx(i),ky(i)));
        E1(i)=vals(1);
        E2(i)=vals(2);
        kv=[kx(i)-M(1),ky(i)-M(2)];
        k(i)=norm(kv)+norm(M-Gamma); % 第二段k路径
        for i=2*kn+1:3*kn
            vals=eig(hamiltonian(kx(i),ky(i)));
            E1(i)=vals(1);
            E2(i)=vals(2);
            kv=[kx(i)-K(1),ky(i)-K(2)];
            k(i)=norm(kv)+norm(M-Gamma)+norm(K-M); % 第三段k路径
        end
    end
end

%% 画图
figure();
grid on
hold on
box on % 加边框
plot(k,E1,'r')
plot(k,E2,'b')
xlim([0 k(3*kn)]) % x轴范围
xticks([0 k(kn) k(2*kn+1) k(3*kn)])
xticklabels({'\Gamma','M','K','\Gamma'})
ylabel("Energy")
title("石墨烯能带")
print("石墨烯",'-dpng','-r600') % 保存为png格式，分辨率600

function H=hamiltonian(kx,ky)
epsilon=-1.01354;t=2.01493;r=-0.337845;
H=zeros(2);
H(1,1)=epsilon+4*r*cos(kx/2)*cos(sqrt(3)*ky/2)+2*r*cos(kx);
H(2,2)=H(1,1);
H(1,2)=t*(exp(1j*(-kx/2-ky/(2*sqrt(3))))+exp(1j*(kx/2-ky/(2*sqrt(3))))+exp(1j*ky/sqrt(3)));
H(2,1)=conj(H(1,2));
end

function H=hami(kx,ky)

eo=-1.01354;
t=2.01493;
r=-0.337845;
k=[kx,ky];
r1=[0,0];
r11=[1,0]; r12=[1/2,sqrt(3)/2];r13=[-1/2,sqrt(3)/2];
r14=[-1,0];r15=[-1/2,-sqrt(3)/2];r16=[1/2,-sqrt(3)/2];

r21=[0,sqrt(3)/3]; r22=[1/2,-sqrt(3)/3];r23=[-1/2,-sqrt(3)/3];

H11_E=eo+r*(exp(1i*k*(r11-r1)')+exp(1i*k*(r12-r1)')+exp(1i*k*(r13-r1)')+exp(1i*k*(r14-r1)')+exp(1i*k*(r15-r1)')+exp(1i*k*(r16-r1)'));
H11=simplify(expand(rewrite(H11_E,'cos')));

% 原子1跃迁到原子1的情况，与原子2跃迁到原子2的情况一样，故H11=H22
H22=H11;

H12=t*(exp(1i*k*(r21-r1)')+exp(1i*k*(r22-r1)')+exp(1i*k*(r23-r1)'));
% 原子1跃迁到原子2的情况，与原子2跃迁到原子1的情况 向量相反;且没有在位能
H21=t*(exp(-1i*k*(r21-r1)')+exp(-1i*k*(r22-r1)')+exp(-1i*k*(r23-r1)'));
H=zeros(2);
H(1,1)=H11;
H(1,2)=H12;
H(2,1)=H21;
H(2,2)=H22;
end


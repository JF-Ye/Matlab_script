clc;
clear;

hrfile = "phonopyTB_hr.dat";
efermi =0;
POSCAR_latt = [
    5.2910456566302368    0.0000000000000000    0.0000000000000000
    -2.6455228283151184    4.5821799512251014    0.0000000000000000
     0.0000000000000000    0.0000000000000000    4.4405574447903495
     ];

a = POSCAR_latt(1,:);
b = POSCAR_latt(2,:);
c = POSCAR_latt(3,:);
omg = dot(a, cross(b,c));
Ba = 2*pi*cross(b,c)/omg;
Bb = 2*pi*cross(a,c)/omg;
Bc = 2*pi*cross(a,b)/omg;

fidt = fopen(hrfile);
fgetl(fidt);
tot_band = str2double(fgetl(fidt));
tot_hp = str2double(fgetl(fidt));
fclose(fidt);

hp_data = readmatrix("phonopyTB_hr.dat","FileType","text","NumHeaderLines",6);

hopping = zeros(1, 3, tot_hp);
for m = 1:tot_hp
    hopping(:, :, m) = hp_data(1 + tot_band^2 * (m - 1), 1:3);  % 提取了每个hopping的跃迁方向
end

hamiltonian=zeros(tot_band,tot_band,tot_hp);
for m=1:tot_hp
    for n=1:tot_band^2
        hamiltonian(hp_data(n+tot_band^2*(m-1),4),hp_data(n+tot_band^2*(m-1),5),m)=...
        hp_data(n+tot_band^2*(m-1),6)+1j*hp_data(n+tot_band^2*(m-1),7);   
        % j 为虚数
    end
end



%%
function H=Hamiltonian(kx,ky,kz)
    % 数据处理
    % efermi=-0.8046;
    wannier90_hrdata=importdata('phonopyTB_hr.dat'); 
    % textData=wannier90_hrdata.textdata; 
    numData=wannier90_hrdata.data; 
    nbands=numData(1);
    nhopping=numData(2);
    % degeneracy=numData(3:nhopping+2);
    numData(1:nhopping+2)=[];
    hoppingdata=reshape(numData,7,[])';
    POSCAR_latt = [
        5.2910456566302368    0.0000000000000000    0.0000000000000000
        -2.6455228283151184    4.5821799512251014    0.0000000000000000
         0.0000000000000000    0.0000000000000000    4.4405574447903495
         ];
    
    a = POSCAR_latt(1,:);
    b = POSCAR_latt(2,:);
    c = POSCAR_latt(3,:);
    % 按照跃迁分组
    hopping=zeros(1,3,nhopping);
    for m=1:nhopping
        hopping(:,:,m)=hoppingdata(1+nbands^2*(m-1),1:3);
    end
    hamiltonian=zeros(nbands,nbands,nhopping);
    for m=1:nhopping
        for n=1:nbands^2
            hamiltonian(hoppingdata(n+nbands^2*(m-1),4),hoppingdata(n+nbands^2*(m-1),5),m)=...
            hoppingdata(n+nbands^2*(m-1),6)+1j*hoppingdata(n+nbands^2*(m-1),7);
        end
    end
    % k空间哈密顿量
    k=[kx ky kz];
    H=zeros(nbands);
    for n=1:nhopping
        temp=hamiltonian(:,:,n)*exp(1j*dot(k,(hopping(:,1,n)*a+hopping(:,2,n)*b+hopping(:,3,n)*c)));
        H=H+temp;
    end
end

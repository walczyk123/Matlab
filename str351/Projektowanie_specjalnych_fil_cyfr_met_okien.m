%==========================================================================
% Projektowanie specjalnych filtrow cyfrowych metoda okien 
%==========================================================================

clear all;
close all;
clc;        

M = 20;                     %polowa dlugosci filtra 
N=2*M+1;                    %cala dlugosc filtra
typ=1;                      %1- Hilberta, 2- rozniczkujacy, 3- interp.
n=1:M;

%=============== teoretyczne odpowiedzi impulsowe =========================

if (typ==1)
    h=(2/pi)*sin(pi*n/2).^2./n;
                            %polowa odp impulsowej n-> liczby calk. <=M
end  

if (typ==2) 
    h=cos(pi*n)./n; 
end                    

if (typ==3)                                              
    K=5; 
    wc=pi/K; 
    fc=wc/(2*pi);           %fc = 1/(2*K)    
    h=2*fc*sin(wc*n)./(wc*n);
                            %2*fc = 1/K 
end
% figure(1)
% plot(h)
if (typ==1 || typ==2)        %generowanie calej odpowiedzi impulsowej
    h = [ -h(M:-1:1) 0 h(1:M) ];
                            %lustrzane odbicie
else
    h = K*[ h(M:-1:1) 2*fc h(1:M)]; 
                            %wzmocnienie K, aby probka srodkowa byla = 1 
end
% figure(2)
% plot(h)

%=============== przemnozenie odpowiedzi przez okno blackmana =============
w=blackman(N)';             %okno Blackmana   
hw=h.*w;                    %wymnozenie odpowiedzi impulsowej z oknem

%============= widmo Fouriera =============================================
m=-M:1:M;                   %dla filtra bez przesunięcia o M próbek w prawo
                            %(nieprzyczynowego)
%m=0:N-1;                   %dla filtra z przesunięciem o M próbek w prawo
                            %(przyczynowego)
NF=500;
fn=0.5*(1:NF-1)/NF;
for k=1:NF-1
    H(k)=sum(h.*exp(-1j*2*pi*fn(k)*m));
    HW(k)=sum(hw.*exp(-1j*2*pi*fn(k)*m));
end

%================ wykresy =================================================
figure;
subplot(2,1,1)
stem(m,h);
grid;
title('h(n)');
xlabel('n');
subplot(2,1,2);
stem(m,hw);
grid;
title('hw(n)');
xlabel('n');

figure;
subplot(4,1,1);
plot(fn,abs(H));
grid;
title('|H(fn)|');
xlabel('f norm]');

subplot(4,1,2);
plot(fn,abs(HW));
grid;
title('|HW(fn)|');
xlabel('f norm]');

subplot(4,1,3);
plot(fn,unwrap(angle(H)));
grid;
title('faza rozwinieta H(fn) [rad]');
xlabel('f norm'); 

subplot(4,1,4);
plot(fn,unwrap(angle(HW)));
grid;
title('faza rozwinieta HW(fn) [rad]');
xlabel('f norm'); 


%% =================== filtr Hilberta i rozniczkujacy =====================

if(typ==1 || typ==2)
    Nx=200;
    fx=50;
    fpr=1000;
    n=0:Nx-1;
    x=cos(2*pi*fx/fpr*n);           %generacja sygnału testowego
     
    y=conv(x,hw);                   %filtracja sygnału x(n) przez hw(n) 
    yp=y(N:Nx);                     %odciecie stanow przejsciowych 
    xp=x(M+1:Nx-M);                 %odciecie tych probek x(n), dla których
                                    %nie ma poprawnych odpowiedników w y(n)
    figure;
    if(typ==1)                      %filtr Hilberta        
        z=xp+1j*yp;                 %sygnal analityczny        
        Ny=ceil(fpr/fx); 
        k=1:Ny; 
        
        subplot(3,1,1);
        plot(k,xp(k),'b',k,yp(k),'r');
        title('xp(n) i yp(n)'); 
        grid; 
        subplot(3,1,2);
        plot(xp,yp); 
        title('Cz. urojona w funkcji cz. rzeczywistej'); 
        grid;
        subplot(3,1,3);
        plot(abs(fft(z))); 
        title('Widmo sygnału analitycznego');                               
    else                            %filtr rozniczkujący        
        Ny=ceil(fpr/fx); 
        k=1:Ny; 
        plot(k,xp(k),'b',k,yp(k),'r'); 
        title('xp(n) i yp(n)');        
        grid; 
    end
end


%% ==================== filtr interpolujacy ===============================
if(typ==3)   
    Nx=50;
    fx=50;
    fpr=1000;
    n=0:Nx-1;
    x=cos(2*pi*fx/fpr*n);           %generacja sygnalu x(n)  
    
    xz=[];
    KNx=K*Nx;
    xz=zeros(1,KNx);
    xz(1:K:KNx)=x(1:Nx);            %dodanie zer 
    
    yz=conv(xz,hw);                 %filtracja xz(n) za pomocą  hw(n) 
    yp=yz(N:KNx);                   %odciecie stanow przejsciowych
    xp=xz(M+1:KNx-M);               %odciecie  probek w xz(n), dla których 
                                    %nie ma popr. odpowiedników w yz(n)  
                                    
    Ny=length(yp);
    k=1:Ny;
    
    figure;
    plot(k,xp(k),'or',k,yp(k),'-b');
    title('xp(n) i yp(n)');
    grid; 
end


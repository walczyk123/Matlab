%==========================================================================
% Transformacja falkowa
%==========================================================================
clc;
clear all;
close all;

niter=6;                    %liczba iteracji
nx=2^niter*32;              %dlugosc sygnalu

%=================== definiowanie wspolczynnikow ==========================
h0s=[(1+sqrt(3))/(4*sqrt(2)) (3+sqrt(3))/(4*sqrt(2)) ... 
    (3-sqrt(3))/(4*sqrt(2)) (1-sqrt(3))/(4*sqrt(2)) ];

N=length(h0s); 
n=0:N-1;

h1s=(-1).^n.*h0s(N:-1:1);   %filtr HP syntezy  
h0a=h0s(N:-1:1);            %filtr LP analizy
h1a=h1s(N:-1:1);            %filtr HP analizy

x=rand(1,nx);               
%x=sin(2*pi*(1:nx)/32);
                            %sygnaly testowe
figure(1);
plot(x);
title('Sygnal testowy');



%========================== analiza =======================================
cc = x;
for m=1:niter
    c0=conv(cc,h0a);        %filtracja LP     
    d0=conv(cc,h1a);        %filtracja HP     
    k=N:2:length(d0)-(N-1); 
    kp=1:length(k); 
    ord(m)=length(kp); 
    dd(m,kp)=d0(k);    
    k=N:2:length(c0)-(N-1); 
    cc=c0(k);  
end

%========================== synteza =======================================
c=cc;
for m=niter:-1:1;
    c0=[]; 
    d0=[];
    for k=1:length(c)
        c0(2*k-1)=c(k);
        c0(2*k)=0;
    end
    c=conv(c0,h0s);
    nc=length(c);
    for k=1:ord(m)
        d0(2*k-1)=dd(m,k);
        d0(2*k)=0;
    end
    d=conv(d0,h1s);
    nd=length(d);
    c=c(1:nd);
    c=c+d;  
end

%========================= wykresy ========================================

figure(2);
n=2*(N-1)*niter:length(c)-2*(N-1)*niter+1;

subplot(3,1,1);
plot(x);
title('Sygnal testowy wejsciowy');

subplot(3,1,2);
plot(c);
title('Sygnal testowy wyjsciowy');

subplot(3,1,3);
plot(n,x(n)-c(n));
title('Wygnal wejsciowy-sygnal wyjsciowy');

















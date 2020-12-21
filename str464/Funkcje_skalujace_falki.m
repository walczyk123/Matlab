%==========================================================================
% Generacja funkcji skalujacych i falek
%==========================================================================
clc;
clear all;
close all;

niter=6;                    %liczba iteracji

c=0;                        %c=1 d=0 -> funkcja skalujaca
d=1;                        %c=0 d=1 -> falka

%=================== definiowanie wspolczynnikow ==========================
h0=[(1+sqrt(3))/(4*sqrt(2)) (3+sqrt(3))/(4*sqrt(2)) ... 
    (3-sqrt(3))/(4*sqrt(2)) (1-sqrt(3))/(4*sqrt(2)) ];
N=length(h0); 
n=0:N-1;
h1=(-1).^n.*h0(N:-1:1);


%================ synteza wg str 463 rys 17.15

c=[0 c 0];                  %aproksymacje 
d=[0 d 0];                  %detale  
c=conv(c,h0)+conv(d,h1);

for n=1:niter
    for k=1:length(c) 
        c0(2*k-1)=c(k);
        c0(2*k)=0;
    end
    c0=[ 0 c0]; 
    c=conv(c0,h0);
end
plot(c);





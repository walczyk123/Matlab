%==========================================================================
% Zaprojektowanie ukladu elektronicznego dolnoprzepustowego filtra
% Butterwortha
%==========================================================================
clear all;
close all;
clc;


apass = 1;                  %nieliniowosc pasma przepustowego w dB 
astop = 50;                 %tlumienie w pasmie zaporowym
fpass = 1000;               %czestot. pasma przepustowego (apass) 
fstop = 4000;               %czestot. pasma zapororwego (astop)

wzm_p=10^(-apass/20)        %tlumienie pass -> wzmocnienie pass
wzm_s=10^(-astop/20)        %tlumienie stop -> wzmocnienie stop

ws=fstop/fpass;             %transformacja czestotliwosci w0=2*pi*fpass
vp=2*pi*fpass;
vs=2*pi*fstop;

f_ps=[fpass,fstop];
wzm_ps=[wzm_p,wzm_s];
wzmdB_ps=[-apass,-astop];

%============== wyznaczenie biegunow filtra LP prototyp ===================
wp=1;
N=ceil(log10((10^(astop/10)-1)/(10^(apass/10)-1))/(2*log10(ws/wp)));
w0=ws/(10^(astop/10)-1)^(1/(2*N));

dfi0=(2*pi)/(2*N);          %kat 
fi=pi/2+dfi0/2+(0:N-1)*dfi0;%katy biegunow
p=w0*exp(1j*fi)             %bieguny
z=[]                        %zera
wzm=real(prod(-p))          %wzmocnienie

figure(1);
plot(real(p),imag(p),'x');
title('Polozenie biegunow');
xlabel('Rzeczywiste');
ylabel('Urojone');

b=wzm;                      %licznik wielomianu B(z)
a=poly(p);                  %mianownik wielomianu A(z)
printsys(b,a,'s')

%========== porownanie wlasnych funkcji z funkcjami MATLABa ===============
[NN,ww0] = buttord(vp,vs,apass,astop,'s');
                            %funkcja zwraca najnizszy rzad cyfrowego filtra
                            %Butterwortha, ktory ma tetnienie pasma
                            %przepustowego mniejsze niz Rp [dB]
blad_N=N-NN

%======= wyznaczenie charakterystyki czestotliwosciowej H(w) ==============
w=0:0.005:2;                %zakres pulsacji unormowanej; 
H=freqs(b,a,w);

figure(2)
subplot(2,1,1);
plot(w,abs(H));
grid;
title('Modul prototypu LowPass');
xlabel('Pulsacja [rad/s]');

subplot(2,1,2);
plot(w,20*log10(abs(H)));
grid; title('Moduł prototypu LowPass w dB');
xlabel('Pulsacja [rad/sek]');
ylabel('dB');

%== Transformata czest. filtra analogowego, filtr unormowany na wynikowy ==

[z,p,wzm]=lp2lpTZ(z,p,wzm,vp);  
                            %z LowPass na LowPass: 
b=wzm*poly(z);              %licznik wielomianu B(z)
a=poly(p);                  %mianownik wielomianu A(z)

%========= zera i bieguny po transf. czestot. =============================

figure(3);
plot(real(z),imag(z),'or',real(p),imag(p),'xb');
grid;
title('Położenie biegunów');
if isempty(z)
    legend('bieguny');
else
    legend('zera','bieguny');
end
xlabel('Rzeczywiste');
ylabel('Urojone');

%% =========== Docelowy filtr po transformacji ============================
z,p,a 
printsys(b,a,'s')

% ======= Koncowa ch-ka czestotliwosciowa =================================
NF=1000;                    %liczba punktow charakterystyki
fmin=0;                     %dolna czestotliwosc
fmax=50000;                 %gorna czestotliwosc
f=fmin:(fmax-fmin)/(NF-1):fmax;
                            %wszystkie czestotliwosci pomiedzy fmin i fmax
w=2*pi*f;                   %wszystkie pulasacje
H=freqs(b,a,w);             %odpowiedz czestotliwosciowa filtra b/a

figure(4);
subplot(3,1,1);
plot(f,abs(H),f_ps,wzm_ps,'ro');
grid;
title('Modul');
xlabel('Czestotliwosc [Hz]');

subplot(3,1,2);
plot(f,20*log10(abs(H)),f_ps,wzmdB_ps,'ro');
axis([fmin,fmax,-100,20]);
grid; title('Modul w dB');
xlabel('Czestotliwosc [Hz]');
ylabel('[dB]');

subplot(3,1,3);
plot(f,unwrap(angle(H)));
grid;
title('Faza, wykres rozwiniety');
xlabel('Czestotliwosc [Hz]');
ylabel('[rad]');

%% ==================== Wzmacniacz RLC ====================================
p1=[p(1) conj(p(1))];
p2=[p(2) conj(p(2))];
p3=p(4);

aw1=poly(p1);
aw2=poly(p2);
aw3=poly(p3);

C=1e-9;                     %odpowiednik 10^(-9) czyli 1 nano Farad (s 169)
RA=1e4;                     %rezystancja miedzy wejsciem (-) wzmacniacza
                            %a masa ukladu, w przykladzie RA=1000
Rwy=1e4;                    %impedancja calego ukladu to rezystancja rowna
                            %Rwy (str 168 wz. 6.90), w przykladzie Rwy=1e4

                            %R, RB, RA - rezystancje (str 169)
                            %K - wzmocnienia
                            %C - pojemnosci, w przykladzie wszystkie rowne
                            
disp('Wyniki dla ukladu 1') %schemat na stronie 170 rys 6.15 uklad 1,2,3
                            %to trzy czesci calego ukladu
a=aw1;
a2=a(1);
a1=a(2);
a0=a(3);
R=1/(C*sqrt(a0))
RB=(2-a1/sqrt(a0))*RA
K1=1+RB/RA

disp('Wyniki dla ukladu 2')
a = aw2;
a2=a(1);
a1=a(2);
a0=a(3);
R=1/(C*sqrt(a0))
RB=(2-a1/sqrt(a0))*RA
K1=1+RB/RA

disp('Wyniki dla ukladu 3')
a=aw3;
a1=a(1);
a0=a(2);
R=1/(C*sqrt(a0))            
RB=(2-a1/sqrt(a0))*RA
K1=1+RB/RA

disp('Obciazenie')
K=K1*K2*K3
G=1                         % G - wzmocnienie (str 168 wz. 6.89)
Rx=(K/G)*Rwy
Ry=(G/K)/(1-G/K)*Rx
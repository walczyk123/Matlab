%==========================================================================
% Projektowanie cyfrowych filtrow Butterwortha LP, HP, BP, BS
% Program wymaga funkcji ze strony 160 oraz 297
%==========================================================================

clear all;
close all;
clc;

typ=1;                  %1-LP, 2-HP, 3-BP, 4-BS
apass=3;                %nieliniowosc pasma przepustowego
astop=60;               %tlumienie w pasmie zaporowym

fpr=2000;               %czestotliowsc probkowania
fmx=1000;               %max czestot na wykresie

%==================== typy filtrow ========================================

if typ==1               %filtr LP
    fpass=200;          %czestotliwosc pasma przepustowego
    fstop=300;          %czestotliwosc pasma zaporowego
    fpass=2*fpr*tan(pi*fpass/fpr)/(2*pi);
                        %zfiltra cyfrowego na analogowy
    fstop=2*fpr*tan(pi*fstop/fpr)/(2*pi);
    ws=fstop/fpass;     %transf. czestotliwosci 
end

if typ==2               %filtr HP
    fpass=800;          %czestotliwosc pasma przepustowego
    fstop=700;          %czestotliwosc pasma zaporowego
    fpass=2*fpr*tan(pi*fpass/fpr)/(2*pi);
                        %zfiltra cyfrowego na analogowy
    fstop=2*fpr*tan(pi*fstop/fpr)/(2*pi);
    ws=fpass/fstop;     %transf. czestotliwosci 
end

if typ==3               %filtr BP
    fs1=300;            %czestotliwosc pasma zaporowego dolna
    fp1=400;            %czestotliwosc pasma przepustowego dolna
    fp2=600;            %czestotliwosc pasma przepustowego gorna
    fs2=700;            %czestotliwosc pasma zaporowego gorna
    
    fp1=2*fpr*tan(pi*fp1/fpr)/(2*pi);
    fp2=2*fpr*tan(pi*fp2/fpr)/(2*pi);
    fs1=2*fpr*tan(pi*fs1/fpr)/(2*pi);
    fs2=2*fpr*tan(pi*fs2/fpr)/(2*pi);
                        %zfiltra cyfrowego na analogowy
    ws1t=(fs1^2-fp1*fp2)/(fs1*(fp2-fp1));
    ws2t=(f21^2-fp1*fp2)/(fs2*(fp2-fp1));                    
                        %transf. czestotliwosci
    ws=min(abs(ws1t),abs(ws2t));                    
end

if typ==4               %filtr BS
    fs1=300;            %czestotliwosc pasma zaporowego dolna
    fp1=400;            %czestotliwosc pasma przepustowego dolna
    fp2=600;            %czestotliwosc pasma przepustowego gorna
    fs2=700;            %czestotliwosc pasma zaporowego gorna
    
    fp1=2*fpr*tan(pi*fp1/fpr)/(2*pi);
    fp2=2*fpr*tan(pi*fp2/fpr)/(2*pi);
    fs1=2*fpr*tan(pi*fs1/fpr)/(2*pi);
    fs2=2*fpr*tan(pi*fs2/fpr)/(2*pi);
                        %zfiltra cyfrowego na analogowy
    ws1t=(fs1*(fp2-fp1))/(fs1^2-fp1*fp2);
    ws2t=(fs2*(fp2-fp1))/(f21^2-fp1*fp2);                    
                        %transf. czestotliwosci
    ws=min(abs(ws1t),abs(ws2t));                    
end

%==================== decybele na wartosci bezwzgledne ====================
wzm_p=10^(-apass/20);
wzm_s=10^(-astop/20);

%==================== parametry pomocnicze ================================

if(typ==1) || (typ==2)
    vp=2*pi*fpass;
    vs=2*pi*fstop;
    f_ps=[fpass, fstop];
    wzm_ps=[wzm_p, wzm_s];
    wzmdB_ps=[-apass, -astop];
end

if (typ==3) || (typ==4)    
    vp=2*pi*[ fp1 fp2 ];
    vs=2*pi*[ fs1 fs2 ];
    vc=2*pi*sqrt(fp1*fp2);      %pulsacja srodka
    dv=2*pi*(fp2-fp1);          %szerokosc pulsacji wookol srodka
    f_ps=[fp1,fp2,fs1,fs2];   
    wzm_ps=[wzm_p, wzm_p, wzm_s, wzm_s];   
    wzmdB_ps=[-apass, -apass, -astop, -astop];
end

%======== wyznaczenie parametrow filtra - rzad, pulsacja ==================
wp=1;
N=ceil(log10((10^(astop/10)-1)/(10^(apass/10)-1))/(2*log10(ws/wp)))
w0=ws/(10^(astop/10)-1)^(1/(2*N))

%========= wyznaczenie biegunow filtra LP prototypowego ===================
dfi0=(2*pi)/(2*N);              %kat
fi=pi/2+dfi0/2+(0:N-1)*dfi0;    %kat biegunow
p=w0*exp(1j*fi);                %bieguny
z=[];                           %zera
wzm=prod(-p);                   %wzmocnienie - iloczyn elementow wektora p
a=poly(p);                      %wspolczynniki mianownika (A(z))
b=wzm;                          %wspolczynniki licznika (B(z))

figure(1);
plot(real(p),imag(p),'x');
grid;
title('Bieguny');
xlabel('Rzeczywiste');
ylabel('Urojone');

%============ porownanie z funkcja MATLABa ================================
[NN,ww0]=buttord(vp,vs,apass,astop,'s');
blad_N=N-NN

%========= charakterystyka czestotliwosciowa prototypu H(w)=B(w)/A(w)

w=0:0.005:2;                    %zakres pulsacji unormowanej
H=freqs(b,a,w);

figure(2);
subplot(211);
plot(w,abs(H));
grid;
title('Modul prototypu LP');
xlabel('Pulsacja [rad/s]');

subplot(212);
plot(w,20*log10(abs(H)));
grid;
title('Modul prototypu LP (dB)');
xlabel('Pulsacja [rad/s]');
ylabel('[dB]');

%====== transformata czestotliwosci - f. analogowy na cyfrowy =============

if (typ==1)                 %LP na LP
    [z,p,wzm]=lp2lpTZ(z,p,wzm,vp);
end
if(typ==2)                  %LP na HP
    [z,p,wzm]=lp2hpTZ(z,p,wzm,vp);
end
if (typ==3)                 %LP na BP
    [z,p,wzm]=lp2bpTZ(z,p,wzm,vc,dv);
end
if (typ==4)                 %LP na BS
    [z,p,wzm]=lp2bsTZ(z,p,wzm,vc,dv);
end 

b=wzm*poly(z); 
a=poly(p);

%===== zera i bieguny po transformacji czestotliwosci =====================

figure(3);
plot(real(z),imag(z),'o',real(p),imag(p),'x');
grid;
title('Polozenie zer i biegunow');
ylabel('Urojone');
xlabel('Rzeczywiste');
printsys(b,a,'s');

%========= koncowa charakterystyka czestotliwosciowa filtra ===============
NF=1000;                        %liczba probek
fmin=0;                         %dolna czestotliwosc
fmax=5000;                      %gorna czestotliwosc
f=fmin:(fmax-fmin)/(NF-1):fmax; %wszystkie czestotliwości
w=2*pi*f;                       %wszystkie pulasacje

H=freqs(b,a,w);
figure(4);
subplot(3,1,1);
plot(f,abs(H),'b',f_ps,wzm_ps,'ro');
grid;
title('Modul');
xlabel('Czestotliwosc [Hz]');

subplot(3,1,2);
plot(f,20*log10(abs(H)),'b',f_ps,wzmdB_ps,'ro');
axis([fmin,fmax,-100,20]);
grid; 
title('Modul [dB]');
xlabel('Czestotliwosc [Hz]');
ylabel('[dB]'); 

subplot(3,1,3);
plot(f,unwrap(angle(H)));
grid;
title('Odpowiedz fazowa,rozwinieta');
xlabel('Czestotliwosc [Hz]');
ylabel('[rad]');

%=============== H(s) -> H(z) === transformata biliniowa ==================
[zc,pc,wzmc]=bilinearTZ(z,p,wzm,fpr);
                            %funkcja z strony 297
                            %konwersja z domeny s na dyskretna z
bc=wzmc*poly(zc);
ac=poly(pc);

%============ zera i bieguny filtra cyfrowego =============================

NP=1000;                    %liczba probek
fi=2*pi*(0:1:NP-1)/NP;      %wektor fi
x=sin(fi);                  %wartosci funkcji sin
y=cos(fi);                  %wartosci funkcji cos

figure(5);
plot(x,y,'-k',real(zc),imag(zc),'or',real(pc),imag(pc),'xb');
title('Zera i bieguny, filtr cyfrowy');
grid;

printsys(b,a,'s');

%============ otrzymana charakterystyka czestotliwosciowa =================

NF=1000;                        %liczba probek
fmin=0;                         %dolna czestotliwosc
fmax=5000;                      %gorna czestotliwosc
f=fmin:(fmax-fmin)/(NF-1):fmax; %wszystkie czestotliwości
w=2*pi*f;                       %wszystkie pulasacje

f_ps=(fpr/pi)*atan(pi*f_ps/fpr);

H=freqs(b,a,w);
figure(6);
subplot(3,1,1);
plot(f,abs(H),'b',f_ps,wzm_ps,'ro');
grid;
title('Modul');
xlabel('Czestotliwosc [Hz]');

subplot(3,1,2);
plot(f,20*log10(abs(H)),'b',f_ps,wzmdB_ps,'ro');
axis([fmin,fmax,-100,20]);
grid; 
title('Modul [dB]');
xlabel('Czestotliwosc [Hz]');
ylabel('[dB]'); 

subplot(3,1,3);
plot(f,unwrap(angle(H)));
grid;
title('Odpowiedz fazowa,rozwinieta');
xlabel('Czestotliwosc [Hz]');
ylabel('[rad]');

%=========== Odp impulsowa ( filtracja sugnalem delty Kronek.) ============ 
Nx=200;
x=zeros(1,Nx);
x(1)=1;
M=length(bc);
N=length(ac);
ac=ac(2:N);
N=N-1;
bx=zeros(1,M);
by=zeros(1,N);
y=[]; 
for n=1:Nx
    bx=[x(n) bx(1:M-1)];
    y(n)=sum(bx.*bc)-sum(by.*ac);
    by=[y(n) by(1:N-1)];
end
n=0:Nx-1;

figure(7);
plot(n,y);
grid;
title('Odpowiedz impulsowa h(n)'); 
xlabel('n'); p




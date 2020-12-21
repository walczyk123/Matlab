%==========================================================================
% Projektowanie transmitancji analogowych filtrow LP, HP, BP, BS typu
% Czybyszewa typu I
% dzialanie programu wymaga funkcji z poprzednich cwiczen
%==========================================================================

clear all;
clc;
close all;

typ = 1;                    %rodzaj filtra 1-LP,2-HP,3-BP,4BS
apass = 1;                  %nieliniowosc pasma przepustowego w dB 
astop = 50;                 %tlumienie w pasmie zaporowym

if (typ==1)                 %filtr dolnoprzepustowy
    fpass = 1000;           %czestot. pasma przepustowego (apass) 
    fstop = 4000;           %czestot. pasma zapororwego (astop)
    ws = fstop/fpass;       %transformacja czestot. s=s'/w0
                            %w0=2*pi*fpass
end

if (typ==2)                 %filtr gornoprzepustowy
    fpass = 3000;           %czestot. pasma przepustowego (apass) 
    fstop = 2000;           %czestot. pasma zapororwego (astop)
    ws = fpass/fstop;       %transformacja czestot. s=s'/w0
                            %w0=2*pi*fpass
end

if (typ==3)                 %filtr pasmowoprzepustowy
    fs1 = 1500;             %dolna czestotliwosc stop 
    fp1 = 2000;             %dolna czestotliwosc pass 
    fp2 = 3000;             %gorna czestotliwosc pass 
    fs2 = 3500;             %gorna czestotliwosc stop 
    
    ws1t=(fs1^2-fp1*fp2)/(fs1*(fp2-fp1));
    ws2t=(fs2^2-fp1*fp2)/(fs2*(fp2-fp1));
                            %transformacje czestotliwosci
    ws=min(abs(ws1t),abs(ws2t));                                                    
end

if (typ==4)                 %filtr pasmowozaporowy
    fs1 = 1500;             %dolna czestotliwosc stop 
    fp1 = 2000;             %dolna czestotliwosc pass 
    fp2 = 3000;             %gorna czestotliwosc pass 
    fs2 = 3500;             %gorna czestotliwosc stop 
    
    ws1t=(fs1*(fp2-fp1))/(fs1^2-(fp2*fp1));
    ws2t=(fs2*(fp2-fp1))/(fs2^2-(fp2*fp1));
                            %transformacje czestotliwosci
    ws=min(abs(ws1t),abs(ws2t));                                                    
end


wzm_p=10^(-apass/20);
wzm_s=10^(-astop/20);       %przeliczenie decybeli na wartosc bezwzgl.


if((typ==1)||(typ==2))
    vp=2*pi*fpass;
    vs=2*pi*fstop;
    
    f_ps=[fpass,fstop];
    wzm_ps=[wzm_p,wzm_s];
    wzmdB_ps=[-apass,-astop];
end
if( (typ==3) || (typ==4) ) 
    vp = 2*pi*[fp1 fp2];
    vs = 2*pi*[fs1 fs2];
    
    vc = 2*pi*sqrt(fp1*fp2);%pulsacja srodka 
    dv = 2*pi*(fp2-fp1);    %szerokość filtra wokol  vc
    
    f_ps = [fp1,fp2,fs1,fs2];     
    wzm_ps = [wzm_p, wzm_p, wzm_s, wzm_s]; 
    wzmdB_ps = [-apass, -apass, -astop, -astop];
end


%================ wyznaczenie biegunow dolnoprzepustowego filtra proto. ===
wp=1;
Nreal=acosh(sqrt((10^(astop/10)-1)/(10^(apass/10-1)))/acosh(ws/wp));
                                %rzad filtra jako N=[M] (str 159 wz. 6.63)
N=ceil( Nreal )

epsi=sqrt(10^(apass/10)-1);
D=asinh(1/epsi)/N;
R1=sinh(D)                      %okrag wewnetrzny (str 159 wz 6.64a)
R2=cosh(D)                      %okrag zewnetrzny (str 159 wz 6.64b)

dfi0=(2*pi)/(2*N);              %kat
fi=pi/2+dfi0/2+(0:N-1)*dfi0;    %katy biegunow
p1=R1*exp(1j*fi);               %bieguny na R1
p2=R2*exp(1j*fi);               %bieguny na R2
p=real(p1) + 1j*imag(p2);       %bieguny wypadkowe
z=[];                           %zera
wzm=prod(-p);                   %wzmocnienie

a=poly(p);                      %bieguny (wsp wielomianu mianownika A(z))
b=wzm;                          %wielomian licznika B(z)
if (rem(N,2)==0) 
    b = b*10^(-apass/20);       %stala skalujaca transm. (str 159 wz.6.69)
end
%========== porownanie wlasnych funkcji z funkcjami MATLABa ===============
[NN,ww0] = cheb1ord(vp,vs,apass,astop,'s');
                            %funkcja zwraca najnizszy rzad cyfrowego filtra
                            %Butterwortha, ktory ma tetnienie pasma
                            %przepustowego mniejsze niz Rp [dB]
blad_N=N-NN

figure(1);
plot(real(p),imag(p),'x');
grid;
title('Polozenie biegunow prototypu');
xlabel('Wartosci rzeczywiste');
ylabel('Wartosci urojone');

%========== obliczenie charakterystyki czestotliwosciowej H(w) ============

w=0:0.005:2;                %zakres pulsacji unormowanej
H=freqs(b,a,w);             %odpowiedz czestotliwosciowa filtra B/A

figure(2);
subplot(2,1,1);
plot(w,abs(H));
grid;
title('Modul prototypu LowPass');
xlabel('Pulsacja [rad/s]');

subplot(2,1,2);
plot(w,20*log10(abs(H)));
grid;
title('Modul prototypu LowPass [dB]');
xlabel('Pulsacja [rad/s]');
ylabel('[dB]');

% Trans. czestot filtra analogowego: prot. unormowany > wynikowy filtr
if (typ==1)
    [z,p,wzm]=lp2lpTZ(z,p,wzm,vp);
end                     % LP na LP: s=s/w0
if (typ==2) 
    [z,p,wzm] = lp2hpTZ(z,p,wzm,vp);
end                     %LP na HP: s=w0/s
if (typ==3) 
    [z,p,wzm] = lp2bpTZ(z,p,wzm,vc,dv); 
end                     %LP na BP: s=(s^2+wc^2)/(dw*s)
if (typ==4) 
    [z,p,wzm] = lp2bsTZ(z,p,wzm,vc,dv);
end                     %LP na BS: s=(dw*s)/(s^2+wc^2)

b=wzm*poly(z);          %konwersja pierwiastkow na wielomian
a=poly(p);

% ======== Pokazanie zer i biegunow po transformacji czestot. =============
figure(3)
plot(real(z),imag(z),'o',real(p),imag(p),'x');
grid;
title('Polozenie zer i biegunow');

if isempty(z)
    legend('bieguny');
else
    legend('zera','bieguny');
end
xlabel('Rzeczywiste');
ylabel('Urojone');

printsys(b,a,'s');

%========= charakterystyka czestotliwosciowa otrzymana ====================
NF=1000;                        %liczba probek
fmin=0;                         %dolna czestotliwosc
fmax=5000;                      %gorna czestotliwosc
f=fmin:(fmax-fmin)/(NF-1):fmax; %wszystkie czestotliwości
w=2*pi*f;                       %wszystkie pulasacje

H = freqs(b,a,w);
figure(4);
subplot(3,1,1);
plot(f,abs(H),'b',f_ps,wzm_ps,'ro');
grid;
legend('Odpowiedz czestotliwosciowa filtra','')
title('Modul');
xlabel('Czestotliwosc [Hz]');

subplot(3,1,2);
plot(f,20*log10(abs(H)),'b',f_ps,wzmdB_ps,'ro');
axis([fmin,fmax,-100,20]);
grid; 
title('Modul [dB]');
legend('Odpowiedz czestotliwosciowa filtra [dB]','')
xlabel('Czestotliwosc [Hz]');
ylabel('[dB]'); 

subplot(3,1,3);
plot(f,unwrap(angle(H)));
grid;
title('Odpowiedz fazowa,rozwinieta');
xlabel('Czestotliwosc [Hz]');
ylabel('[rad]');

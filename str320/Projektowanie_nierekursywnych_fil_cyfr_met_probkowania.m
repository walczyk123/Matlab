%==========================================================================
% Projektowanie nierekursywnych filtrow cyfrowych metoda probkowania w
% dziedzinie czestotliwosci i optymalizacji sredniokwadratowej
%==========================================================================
close all;
clear all;
clc;

M=20;                   %polowa dlugosci filtra
N=2*M+1;                %dlugosc filtra
K=50;                   %liczba punktow ch-ki czestot. (parzysta, K=>2M)

L1=floor(K/4);          %liczba jedynek 
Ak=[ones(1,L1) 0.75 0.25 zeros(1,K-(2*L1-1)-4) 0.25 0.75 ones(1,L1-1)];
                        %wektor skladajacy sie z L1 jedynek, potem 
                        %przejscie do zer i przejscie do jedynek
Ak=Ak';                 %zmiana wektora na pionowy

wp=1;                   %waga odcinka PassBand
wt=1;                   %waga odcinka TransientBand (przejscia)
ws=1;                   %waga odcinka StopBand

w=[wp*ones(1,L1) wt wt ws*ones(1,K-(2*L1-1)-4) wt wt wp*ones(1,L1-1)];

W=zeros(K,K);           %macierz pusta, kwadratowa
                        %[0   0   0;
                        % 0   0   0;
                        % 0   0   0]
for i=1:K
    W(i,i)=w(i);        %petla dodajaca do macierzy, wagi na przekatnej
end                     %[w   0   0;
                        % 0   w   0;
                        % 0   0   w]
                        
F=[];                   %inicjalizacja macierzy F
n=0:M-1;

for i=0:K-1             %wyznaczenie macierzy F (strona 318 wz 12.43)
    F=[F; 2*cos(2*pi*(M-n)*i/K) 1];
end

%=========== dla h minimalizujacego, blad WFh=WAk

h = pinv(W*F)*(W*Ak);
h = [ h; h(M:-1:1) ];

n=0:2*M;

figure(2)
stem(n,h);
grid;
title('Odpowiedz impulsowa filtra');
xlabel('Numer probki');

NF=500;
wn=0:pi/(NF-1):pi;
fn=wn/(2*pi);
H=freqz(h,1,wn);

figure(3)
subplot(311);
plot(fn,abs(H));
grid;
title('Odpowiedz czestotliwosciowa - Modul');

subplot(312);
plot(fn,20*log10(abs(H)));
grid;
title('Modul odpowiedzi czestotliwosciowej [dB]');
xlabel('Czestotliwosc norm [Hz]');
axis([0 0.5 -100 10]);

subplot(313);
plot(fn,180/pi*unwrap(angle(H)));
grid;
title('Faza odppowiedzi czestotliwosciowej');
ylabel('Stopnie');
xlabel('Czestotliwosc norm [Hz]');



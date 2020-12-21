%==========================================================================
%1. Wygeneruj N=1000 próbek sygnału sinusoidalnego x(t)=Asin(2*pi*fxt) o 
%amplitudzie A=5 i o częstotliwości fx=10 Hz, sprobkowanego z 
%czestotliwoscia fp=1000 Hz. Narysuj ten sygnal.
%==========================================================================
clc;
close all;
clear all;

N=1000;                 %liczba probek
A=5;                    %amplituda sygnalu
fx=10;                  %czestotliwosc sygnalu
fp=1000;                %czestotliwosc probkowania
dt=1/fp;                %dlugosc jednej probki
t=dt*(0:N-1);           %wektor czasu

x=A*sin(2*pi*fx*t);     %wartosci sygnalu

figure(1);
plot(t,x);

title('Przebieg sygnalu x(t)');
xlabel('Czas t[s]');
grid on;

%=============== parametry sygnalow =======================================
x_sred1=mean(x);        %wartosc srednia z uzyciem funckcji wbudowanej
x_sred2=sum(x)/N;       %wartosc srednia wyliczona recznie
x_max=max(x);           %wartosc maksymalna
x_min=min(x);           %wartosc minimalna
x_std1=std(x);          %odchylenia stadnardowe (funkcja wbudowana)
x_std2=sqrt(sum((x-x_sred1).^2)/(N-1));
                        %odchylenie standardowe (wyliczone recznie)
x_eng=dt*sum(x.^2);     %energia sygnalu
x_moc=sum(x.^2)/N;      %moc sygnalu
x_skut=sqrt(x_moc);     %wartosc skuteczna

%============== funkcja autokorelacji R1,R2,R3 -x(t)=======================

R1=xcorr(x);            %nieunormowana
R2=xcorr(x,'biased');   %unormowana przez dlugosc
R3=xcorr(x,'unbiased'); %unormowana przez N-abs(k)  
tR=[-fliplr(t) t(2:N)]; %odwrocenie wektora, w macierzy odw. wierszy
figure(2);
subplot(3,1,1);
plot(tR,R1,'r');
title('Autokorelacja R1 sygnalu x(t)');
subplot(3,1,2);
plot(tR,R2,'g');
title('Autokorelacja R2 sygnalu x(t)');
subplot(3,1,3);
plot(tR,R3,'k');
title('Autokorelacja R3 sygnalu x(t)');
grid;

%============= obliczenie R3 samemu =======================================

for i=0:N
    R(i+1)=sum(x(1:N-i).*x(1+i:N) )/(N-i);
                        %obliczenie autokorelacji -> wartosc x(i) mnozona
                        %jest przez wartosc x(max-i), nastepnie dzielona
                        %przez indeks w wektorze
end
RR=[fliplr(R) R(2:N-1)];
figure(3);
plot(tR,RR,'b');
title('Autokorelacja R3 sygnalu x(t)');

%========= obliczenie wspolczynnikow zespolonego szeregu Fouriera=========

X=fft(x);               %wbudowana funkcja szybkiej dyskretnej t. Fouriera
df=1/(N*dt);            %czestotliwosc podstawowa
f=df*(0:N-1);           %wektor czestotliwosci w szeregu Fouriera
figure(4);

subplot(311);
plot(f,real(X));
grid;
title('Czesc rzeczywista(X)');
xlabel('Hz');

subplot(312);
plot(f,imag(X));
grid;
title('Czesc urojona (X)');
xlabel('Hz');

subplot(313);
plot(f,abs(X));
grid;
title('Wartosc bezwzgledna (X)');
xlabel('Hz');

figure(5)
plot(f(1:N/2+1),abs(X(1:N/2+1))/(N/2));
                        %polowa wektora czestotliwosci (dodatnie
                        %wartosci) oraz wartosci bezwzgledne dla dodatniej
                        %czesci odniesione do ilosci probek 2500/(1000/2)=5
grid;
title('Po wyskalowaniu');

%==== synteza sygnalu na podstawie jego wspolczynnikow szeregu Fouriera ===

xs=ifft(X);             %odwrotna dyskretna transformata Fouriera (inverse)
figure(6);
subplot(2,1,1)
plot(t,x,'r'); hold on;
plot(t,real(xs),':b');hold off;
title('Przebieg sygnalu x(t)');
xlabel('Czas t[s]');
grid on;
legend('pierwotny','otrzymany');
subplot(2,1,2)
plot(t,real(x-xs));
title('Roznica miedzy oryginalnym a otrzymanym sygnalem)');
xlabel('Czas t[s]');

%% ========================================================================
%2. Wygeneruj N=1000 próbek szumu o roskładzie równomiernym i normalnym,
%wyznacz dla nich funkcje autokorelacji, autokowariancji, histogram, szereg
%fouriera i periodogram
%==========================================================================

s1=rand(1,N);               %losowe probki wg rozkladu rownomiernego
s2=randn(1,N);              %losowe probki wg rozkladu normalnego

R1=xcorr(s1,'unbiased');    %autokorelacja unormowana przez N-abs(k) 
R2=xcorr(s2,'unbiased');

figure(7);
subplot(2,1,1);
plot(tR,R1);
title('Autokorelacja szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(tR,R2);
title('Autokorelacja szumu (rozklad normalny)');

C1=xcov(s1);                %kowariancja 
C2=xcov(s2);    
figure(8);
subplot(2,1,1);
plot(tR,C1);
title('Kowariancja szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(tR,C2);
title('Kowariancja szumu (rozklad normalny)');

Hs1=hist(s1,100);           %histogram sygnalu (100 -> ilosc przedzialow)
Hs2=hist(s2,100);
figure(9);
subplot(2,1,1);
plot(Hs1);
title('Histogram szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(Hs2);
title('Histogram szumu (rozklad normalny)');

S1=fft(s1);
S2=fft(s2);
figure(10);
subplot(2,1,1);
plot(f,abs(S1));
title('Widmo Fouriera szumu (rozklad rownomierny)');
xlabel('Czestotliwosc [Hz]');
subplot(2,1,2);
plot(f,abs(S2));
title('Widmo Fouriera szumu (rozklad normalny)');
xlabel('Czestotliwosc [Hz]');

[Pss1,fss1]=periodogram(s1,[],N/10,fp);   
[Pss2,fss2]=periodogram(s2,[],N/10,fp); 
                        %(psd) usrednienie widma odcinkow sygnalu dl. N/10
figure(11);
subplot(2,1,1);
plot(fss1,Pss1);
title('Widmo usrednione (rozklad rownomierny)');
xlabel('Czestotliwosc [Hz]');
subplot(2,1,2);
plot(fss2,Pss2);
title('Widmo usrednione (rozklad normalny)');
xlabel('Czestotliwosc [Hz]');         


%% ========================================================================
%3. Dodaj sygnaly z punktu 1 i 2, wyznacz i narysuj funkcje autokorelacji,
%autokowariancji i histogram sygnalu sumarycznego
%==========================================================================

syg1=x+s1;              %sygnal sinusoidalny plus szum (r. rownomierny)
syg2=x+s2;              %sygnal sinusoidalny plus szum (r. normalny)

RR1=xcorr(syg1,'unbiased');
RR2=xcorr(syg2,'unbiased');
figure(12);
subplot(2,1,1);
plot(tR,RR1);
title('Autokorelacja sygnalu oraz szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(tR,RR2);
title('Autokorelacja sygnalu oraz szumu (rozklad normalny)');

CC1=xcov(syg1);
CC2=xcov(syg2);    
figure(13);
subplot(2,1,1);
plot(tR,CC1);
title('Kowariancja sygnalu oraz szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(tR,CC2);
title('Kowariancja sygnalu oraz szumu (rozklad normalny)');

His1=hist(syg1,100);          %histogram sygnalu (100 -> ilosc przedzialow)
His2=hist(syg2,100);
figure(14);
subplot(2,1,1);
plot(His1);
title('Histogram sygnalu oraz szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(His2);
title('Histogram sygnalu oraz szumu (rozklad normalny)');

%% ========================================================================
%4. Dodaj sygnaly z punktu 1 i 2 oraz sinusoide f=250Hz, wyznacz i narysuj 
%funkcje autokorelacji,autokowariancji i histogram sygnalu sumarycznego
%==========================================================================

f250=250;               %czestotliwosc nowej harmonicznej
sin250=A*sin(2*pi*f250*t);
syg3=x+s1;              %sygnal sinusoidalny plus szum (r. rownomierny)
syg4=x+s2;              %sygnal sinusoidalny plus szum (r. normalny)

RR3=xcorr(syg3,'unbiased');
RR4=xcorr(syg4,'unbiased');
figure(15);
subplot(2,1,1);
plot(tR,RR3);
title('Autokorelacja syg, sin f=250Hz oraz szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(tR,RR4);
title('Autokorelacja syg, sin f=250Hz  oraz szumu (rozklad normalny)');

CC3=xcov(syg3);
CC4=xcov(syg4);    
figure(16);
subplot(2,1,1);
plot(tR,CC3);
title('Kowariancja sygnalu, sin f=250Hz oraz szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(tR,CC4);
title('Kowariancja sygnalu, sin f=250Hz  oraz szumu (rozklad normalny)');

His3=hist(syg3,100);          %histogram sygnalu (100 -> ilosc przedzialow)
His4=hist(syg4,100);
figure(17);
subplot(2,1,1);
plot(His3);
title('Histogram sygnalu, sin f=250Hz  oraz szumu (rozklad rownomierny)');
subplot(2,1,2);
plot(His4);
title('Histogram sygnalu, sin f=250Hz  oraz szumu (rozklad normalny)');

%% ========================================================================
%5. Zmoduluj w amplitudzie sygnal sinusoidalny z punktu pierwszego
%==========================================================================

amp1=hamming(N)';           %tworzy okno hamminga dlugosci N (symetria)
y1=amp1.*x;                 %modulacja kazdego elementu sygnalu
                            %z kazdym elementem okna hamminga
amp2=exp(-10*t);            %funkcja ekspotencjalna
y2=amp2.*x;                 %modulacja
                            
figure(18);
subplot(2,1,1);
plot(t,y1);
title('Sygnal modulowany kodem hamminga');
subplot(2,1,2);
plot(t,y2);
title('Sygnal modulowany z uzyciem f. ekspotencjalnej');


%% ========================================================================
%6. Wygeneruj sygnal sinusoidalny z liniowa modulacja czestotliwosci oraz z
%sinusoidalna modulacja czestotliwosci
%==========================================================================

fx1=0;
fx2=10;                     %czestotliwosc glowna
fm=2;                       %czestotliwosc modulujaca
df1=10;                     %glebokosc modulacji
alfa=10;

y3=sin(2*pi*(fx*t+0.5*alfa*t.^2));
y4=sin(2*pi*(fx2*t+df*sin(2*pi*fm*t)/(2*pi*fm)));
figure(19);
subplot(2,1,1);
plot(t,y3);
title('Sygnal z liniowa modulacja częstotliwosci');
subplot(2,1,2);
plot(t,y4);
title('Sygnal z sinusoidalna modulacja częstotliwosci');


%% ========================================================================
%7. Sklej dwa sygnaly y1 i y4
%==========================================================================


y5=[y1 y4];                 %na koncu jednego sygnalu zaczyna sie nastepny

figure(20);
plot(y5);
title('sklejony sygnal');


%% ========================================================================
%8. Splot dwoch sygnalow (filtracja jednego przez drugi)
%==========================================================================

T=5;                        %czas
N=1000;                     %liczba probek
dt1=T/N;                    %dlugosc probki
t1=dt1*(0:N);               %wektor czasu 

x1=sin(2*pi*2*t1)+0.5*sin(2*pi*8*t1);
                            %sygnal filtrowany zlozony z 2 sin. (2 i 8 Hz)
h=sin(2*pi*2*t1).*exp(-4*t1); %sygnal filtrujacy
y6=conv(x1,h);              %operacja splotu 2 sygnalow


figure(21);
subplot(3,1,1);
plot(t1,x1);
title('Sygnal wejsciowy x(t)');
subplot(3,1,2);
plot(t1,h);
title('Odpowiedz impulsowa h(t)');
subplot(3,1,3);
plot(t1,y6(1:N+1));
title('Sygnal wyjsciowy y(t)');

%pause;

%% ========================================================================
%9. Skwantuj sygnal x(t) z poprzedniego punktu
%==========================================================================


x_min1=-1.5;                %minimum
x_max1=1.5;                 %maksimum
x_zakres=x_max1-x_min1;     %zakres

Nb=3;                       %liczba bitow
Nq=2^Nb;                    %szerokosc przedzialu kwantyzacji

dx=x_zakres/Nq;
xq=dx*round(x1/dx);         %kwantyzacja sygnalu

figure(22);
subplot(2,1,1);
plot(t1,x1);
title('Sygnal oryginalny');
subplot(2,1,2);
plot(t1,xq);
title('Sygnal skwantowany');









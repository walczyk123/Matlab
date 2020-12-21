%==========================================================================
%Program majacy na celu wygenerowanie sygnalu poliharmonicznego,
%sprawdzenie dzialania filtrow z roznymi czestotliwosciami odciecia oraz
%przy dwoch czestotliwosciach odciecia
%==========================================================================
clc;
clear all;
close all;

f1=100;                 %czestotliwosc sygnalu 1    [Hz]
f2=250;                 %czestotliwosc sygnalu 2    [Hz]
f3=400;                 %czestotliwosc sygnalu 3    [Hz]

fs=1e3;                 %czestotliwosc probkowania sygnalow[Hz]
fod1=300;               %czestotliwosc odciecia 1 [Hz]
fod2=200;               %czestotliwosc odciecia 2 [Hz]
omega1=2*fod1/fs;       %czestotliwosc odciecia 1 [rad]
omega2=2*fod2/fs;       %czestotliwosc odciecia 2 [rad]

A1=1;                   %amplituda sygnalu 1
A2=0.8;                 %amplituda sygnalu 2
A3=0.65;                %amplituda sygnalu 3

t=0:(1/fs):1.023;       %wektor czasu 

x=A1*sin(2*pi*f1*t)+A2*sin(2*pi*f2*t)+A3*sin(2*pi*f3*t);
                        %wartosci funkcji poliharmonicznej w czasie t
                        
fft_moc=fft(x(1:length(x)));
                        %transformata fouriera sygnalu x
moc_wid=fft_moc.*conj(fft_moc)/length(x);
                        %gestosc widmowa mocy sygnalu x
f=fs*(0:length(x)-1)/length(x);
widmo(1,:)=sqrt(fft_moc.*conj(fft_moc))/length(x);
                        %1 - widmo sygnalu x 
                        %2 - widmo sygnalu x_butter
%% Filtr dolnoprzepustowy Butterworth, czestotliwosc odciecia 300Hz
N=[2,4,8];
[L,M]=butter(N(1,3),omega1);
                        %projektuje filtr dolnoprzepustowy N-stopnia i
                        %zwraca wektory wspolczynnikow w ilosci N+1, gdzie
                        %wektor L - licznik, M - mianownik. Ostatni
                        %parametr musi zawierac sie miedzy 0 a 1 gdzie 1 to
                        %polowa czestosci probkowania
                        
x_butter=filter(L,M,x);  %filtracja sygnalu x, wspolczynnikami L i M

fft_moc=fft(x_butter(1:length(x)));
                        %transformata fouriera sygnalu x_butter
moc_wid=fft_moc.*conj(fft_moc)/length(x);
                        %gestosc widmowa mocy sygnalu x_butter
widmo(2,:)=sqrt(fft_moc.*conj(fft_moc))/length(x);
                    
figure(1);
subplot(2,1,1);
plot(t,x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal oryginalny');

subplot(2,1,2);plot(t,x_butter);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal filtrowany fod1=300 Hz');

figure(2);
subplot(2,1,1);
plot(f(1,(1:length(x)/2)),widmo(1,(1:length(x)/2)));
xlabel('Czestotliwosc[Hz]');
ylabel('Widmo transformaty Fouriera');
title('Sygnal oryginalny');

subplot(2,1,2)
plot(f(1,(1:length(x)/2)),widmo(2,(1:length(x)/2)))
xlabel('Czestotliwosc [Hz]');
ylabel('Widmo transformaty Fouriera');
title('Sygnal filtrowany fod1=300 Hz');

%% Filtr dolnoprzepustowy Butterworth, czestotliwosc odciecia 200Hz
N=[2,4,8];
[L,M]=butter(N(1,3),omega2);
                        %filtr dolnoprzepustowy N-stopnia 
                        %zwraca wektory wspolczynnikow w ilosci N+1, gdzie
                        %wektor L - licznik, M - mianownik. 
                   
x_butter=filter(L,M,x);  %filtracja sygnalu x, wspolczynnikami L i M

fft_moc=fft(x_butter(1:length(x)));
                        %transformata fouriera sygnalu x_butter
moc_wid=fft_moc.*conj(fft_moc)/length(x);
                        %gestosc widmowa mocy sygnalu x_butter
widmo(3,:)=sqrt(fft_moc.*conj(fft_moc))/length(x);
                    
figure(3);
subplot(2,1,1);
plot(t,x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal oryginalny');

subplot(2,1,2);plot(t,x_butter);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal filtrowany fod2=200 Hz');

figure(4);
subplot(2,1,1);
plot(f(1,(1:length(x)/2)),widmo(1,(1:length(x)/2)));
xlabel('Czestotliwosc[Hz]');
ylabel('Widmo transformaty Fouriera');
title('Sygnal oryginalny');

subplot(2,1,2)
plot(f(1,(1:length(x)/2)),widmo(3,(1:length(x)/2)))
xlabel('Czestotliwosc [Hz]');
ylabel('Widmo transformaty Fouriera');
title('Sygnal filtrowany fod2=200 Hz');

%% Filtr srednioprzepustowy Butterworth, czest. odciecia 200Hz oraz 300Hz
N=[2,4,8];
[L,M]=butter(N(1,3),[omega2 omega1]);
                        %filtr pasmowoprzepustowy N-stopnia 
                   
x_butter=filter(L,M,x);  %filtracja sygnalu x, wspolczynnikami L i M

fft_moc=fft(x_butter(1:length(x)));
                        %transformata fouriera sygnalu x_butter
moc_wid=fft_moc.*conj(fft_moc)/length(x);
                        %gestosc widmowa mocy sygnalu x_butter
widmo(4,:)=sqrt(fft_moc.*conj(fft_moc))/length(x);
                    
figure(5);
subplot(2,1,1);
plot(t,x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal oryginalny');

subplot(2,1,2);plot(t,x_butter);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal filtrowany fod2=200 Hz oraz  fod1=300 Hz');

figure(6);
subplot(2,1,1);
plot(f(1,(1:length(x)/2)),widmo(1,(1:length(x)/2)));
xlabel('Czestotliwosc[Hz]');
ylabel('Widmo transformaty Fouriera');
title('Sygnal oryginalny');

subplot(2,1,2)
plot(f(1,(1:length(x)/2)),widmo(4,(1:length(x)/2)))
xlabel('Czestotliwosc [Hz]');
ylabel('Widmo transformaty Fouriera');
title('Sygnal filtrowany  fod2=200 Hz oraz fod1=300 Hz');

%% Filtr gornoprzepustowy Butterworth, czestotliwosc odciecia 300Hz
N=[2,4,8];
[L,M]=butter(N(1,3),omega1,'high');
                        %filtr gornoprzepustowy N-stopnia 'high' -GP               
x_butter=filter(L,M,x);  %filtracja sygnalu x, wspolczynnikami L i M

fft_moc=fft(x_butter(1:length(x)));
                        %transformata fouriera sygnalu x_butter
moc_wid=fft_moc.*conj(fft_moc)/length(x);
                        %gestosc widmowa mocy sygnalu x_butter
widmo(5,:)=sqrt(fft_moc.*conj(fft_moc))/length(x);
                    
figure(7);
subplot(2,1,1);
plot(t,x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal oryginalny');

subplot(2,1,2);plot(t,x_butter);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal filtrowany fod2=300 Hz');

figure(8);
subplot(2,1,1);
plot(f(1,(1:length(x)/2)),widmo(1,(1:length(x)/2)));
xlabel('Czestotliwosc[Hz]');
ylabel('Widmo transformaty Fouriera');
title('Sygnal oryginalny');

subplot(2,1,2)
plot(f(1,(1:length(x)/2)),widmo(5,(1:length(x)/2)))
xlabel('Czestotliwosc [Hz]');
ylabel('Widmo transformaty Fouriera');
title('Sygnal filtrowany fod2=300 Hz');



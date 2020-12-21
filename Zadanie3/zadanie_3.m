%==========================================================================
% kazdy z podpunktow zadania jest w osobnej sekcji, nalezy wlaczac
% poszczegolne sekcje oddzielnie a nie caly kod
%
%funkcja wavewrite jest zastapiona audiowrite w nowym matlabie
%funkcja waveread jest zastapiona audioread
%==========================================================================
clc;
clear all;
close all;

A=0.5;              %amplituda 1 0.5
f1=700;             %czestotliwosc 1 700Hz   
fs=1e4;             %czest. probkowania 10000
t=0:(1/fs):1;       %wektor czasu z krokiem 1/il. probek

omega1=2*pi*f1;     %obliczenie czestosci 1
y1=A*sin(omega1*t); %obliczenie funkcji 1

audiowrite('dzwiek1.wav',y1,fs);
                    %zapisanie pliku z dzwiekiem funkcji y1
                    %czestotliwosc fs, 
close all;
[y,FS]=audioread('dzwiek1.wav');
                    %odzczyt pliku z dzwiekiem
close all;
%% drugi dzwiek
clc;
close all;

B=1;                %amplituda 2 1
f2=700;             %czestotliwosc 2 700Hz   
f3=70;              %czestotliwosc 3 70Hz 
fs=1e4;             %czest. probkowania 10000
t=0:(1/fs):1;       %wektor czasu z krokiem 1/il. probek
alfa1=2;
alfa2=6;

omega2=2*pi*f2;     %obliczenie czestosci 2
omega3=2*pi*f3;     %obliczenie czestosci 3
y2=B*sin(omega2*t); %obliczenie funkcji 2

ym1=2*B*y2.*sin(omega3*t);
ym2=sin(2*pi*10*t).*sin(2*pi*1000*t);
ym3=sin(2*pi*10*t).*sin(2*pi*1000*t).*exp(-alfa1*t); 
                    %funkcja z tlumieniem alfa1
ym4=sin(2*pi*10*t).*sin(2*pi*1000*t).*exp(-alfa2*t);
                    %funkcja z tlumieniem alfa2

figure(1)           %nowe okno wykresow
subplot(2,2,1)      %podzial okna na 4 czesc (2 kol, 2wier) i wybor pozycji
plot(t,ym1);        %wyrysowanie funkcji ym1(t)
title('funkcja ym1');

subplot(2,2,2)      %podzial okna na 4 czesc (2 kol, 2wier) i wybor pozycji
plot(t,ym2);        %wyrysowanie funkcji ym2(t)
title('funkcja ym2');

subplot(2,2,3)      %podzial okna na 4 czesc (2 kol, 2wier) i wybor pozycji
plot(t,ym3);        %wyrysowanie funkcji ym3(t)
title('funkcja ym3');

subplot(2,2,4)      %podzial okna na 4 czesc (2 kol, 2wier) i wybor pozycji
plot(t,ym4);        %wyrysowanie funkcji ym4(t)
title('funkcja ym4');

Y2=[ym3(:), ym4(:)];%utworzenie macierzy z wektorow ym3 i ym4

audiowrite('dzwiek2.wav',Y2,fs,'BitsPerSample',24);
                    %zapisanie pliku z dzwiekiem Y2
                    %czestotliwosc fs, 
[Y3,FS]=audioread('dzwiek2.wav');
                    %odzczyt pliku z dzwiekiem


figure(2)           %nowe okno wykresów
plot(Y3(:,1),'r');  %wyrysowanie pierwszego wektora
hold on;
plot(Y3(:,2),'b');  %wyrysowanie drugiego wektora
hold off;

%% jeden dzwiek narasta, drugi jest tlumiony
ym5=ym1.*(1-exp(-alfa2*t));
                    %obliczenie wartosci funkcji narastajacej
Y4=[ym3(:), ym5(:)];%utworzenie macierzy z wektorow ym3 i ym5

audiowrite('dzwiek3.wav',Y4,fs,'BitsPerSample',24);
                    %zapisanie pliku z dzwiekiem Y2
                    %czestotliwosc fs, 
[Y5,FS]=audioread('dzwiek3.wav');

figure(3)           %nowe okno wykresów
plot(Y5(:,2),'r');  %wyrysowanie pierwszego wektora
hold on;
plot(Y5(:,1),'b');  %wyrysowanie drugiego wektora
hold off;

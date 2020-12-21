%==========================================================================
%przykladowy program wyznaczajacy gestosc widmowa mocy sygnalu
%==========================================================================
clc;
clear all;
close all;

f=100;                      %czestotliwosc 100Hz
fs=1e3;                     %czestotliwosc probkowania 1kHz
t=0:(1/fs):2;               %wektor czasu
A=1;                        %amplituda sygnalu

omega=2*pi*f;               %obliczenie omegi
y=A*sin(omega*t);           %obliczenie wartosci funkcji 1

N=1024;
fft_moc=fft(y(1:N));        %zmienna pomocnicza
moc_wid=fft_moc.*conj(fft_moc)/N;
                            %gestosc widmowa mocy, conj-zmiania znaku czêœci
                            %urojonej danej liczby zespolonej.  
                            
f_f=0:fs/N:(fs-1)/2;        %wektor czestotliwosci (2x mniej ele. niz w N)
figure(1);                  %nowy wykres
plot(f_f,moc_wid(1:N/2));   %wykres gestosci widmowej mocy sygnalu
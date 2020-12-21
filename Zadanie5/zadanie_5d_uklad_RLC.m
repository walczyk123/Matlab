%==========================================================================
%Uklad RLC, Rezystancja R=1kOhm, Indukcja L=1H, Pojemnosc C=10e-6F
%wymagany jest conajmniej jeden z toolboxow do dzialania programu:
% - Control System toolbox
% - DSP System toolbox
% - Model Predictive Control toolbox
% - Signal Processing toolbox
%==========================================================================
clc;
clear all;
close all;

R=1e3;              %Rezystancja 1kOhm
C=1e-6;             %Pojemnosc kondensatora 10^(-6)F
Lc=1;               %Indukcyjnosc cewki 1H

figure(1);          %pokazanie shematu ukladu RLC w nowym oknie
schemat = imread('ukladRLC.png');
imshow(schemat);
title('Schemat omawianego ukladu RLC');

L=1;                %licznik (numerator NUM)
M=[(Lc*C) (R*C) 1]; %mianownik (denominator DEN)
sys=tf(L,M)         %wyznaczenie funkcji przejscia
                
figure(2);          
freqs(L,M);         %okno charakterystyk ampl-czestot. oraz fazowo-czestot.

figure(3);
impulse(L,M);       %okno charakterystyk odpowiedzi impulsowej ukladu

figure(4);
step(L,M);          %okno ch-k odpowiedzi na wymuszenie skokowe ukladu

figure(5);
iopzplot(sys);      %wykres badania stabilnosci zer i biegunow

[z,p,k]=tf2zp(L,M)  %konwersja parametrow funkcji przejscia na zera, 
                    %bieguny oraz wzmocnienia
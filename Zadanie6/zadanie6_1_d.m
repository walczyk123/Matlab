%==========================================================================
%Pokazanie dla danych transmitacji:
%-odpowiedzi impulsowej,
%-charakterystyki amplitudowo-czestotliwosciowej
%-charakterystyki fazowe
%-zbadać stablinosc,
%Dodatkowo sprawdzenie danego filtra sygnalem zlozonym z 3 sygnalow
%sinusoidalnych. Filtr projektowany za pomoca metody Yule-Walkera i za
%pomoca polecenia fir2
%==========================================================================
clc;
close all;
clear all;

fs=1000;                    %czestotliwosc probkowania
f=100;                      %czestotliwosc sygnalu
L=[0.1239 -0.0662 0.1239];  %licznik transmitancji
M=[1 -1.4412 0.6979];       %mianownik transmitancji
sys=tf(L,M);                %zbudowanie funkcji przejscia
t=0:(1/fs):1;               %wektor czsu

delta_k=zeros(1,length(t)); %delta kronekera (zera w calym sygnale,
delta_k(1,1)=1;             %pierwsza próbka jest rowna 1)

figure(1);
[H,W]=freqz(L,M);           %odpowiedz czestotliwosciowa filtra
freqz(L,M);                 %wykres amplitudy i fazy(rozwiniety) filtra

Mod=20*log10(abs(H));       %modul [dB]
Fi_rad=phase(H);            %faza sygnalu [rad]
Fi_deg=Fi_rad*180/pi;       %faza sygnalu [deg]
W_norm=W/pi;                %czestotliwosc znormalizowana 

figure(2);
subplot(2,1,1);
plot(W_norm,Mod);           %wykr. modulu od czestotliwosci znormalizowanej
title('Odpowiedz amplitudowo-czestotliwosciowa filtra');
ylabel('Modul [dB]');
xlabel('Czestotliwosc znormalizowana ');
subplot(2,1,2);
plot(W_norm,Fi_deg);        %wykr. fazy od czestotliwosci znormalizowanej
title('Odpowiedz fazowo-czestotliwosciowa filtra');
ylabel('Faza[\circ]');
xlabel('Czestotliwosc znormalizowana ');

figure(3);
dimpulse(L,M);              %odpowiedz impulsowa filtra

odp_imp=filter(L,M,delta_k);%filtrowanie sygnalu delta_k za pomoca filtra 
                            %opisanego za pomoca L i M, tworzy nowy wektor
figure(4);
subplot(2,1,1);
plot(t,delta_k);            %wykreslenie przebiegu f. delty kroneckera
xlabel('czas [s]');
ylabel('Amplituda')
title('Sygnal przed filtracja');
subplot(2,1,2);
plot(t,odp_imp);            %wykreslenie przebiegu f. delty k. po filtr.
xlabel('czas [s]');
ylabel('Amplituda');
title('Sygnal po filtracji');

figure(5);
x_offset=0;                 %odsuniecie okregu na osi X
y_offset=0;                 %odsuniecie okregu na osi Y
radius=1;                   %promien okregu 

x = linspace(x_offset-radius,x_offset+radius,100);
                            %wektor wartosci X okregu
circ1=sqrt(radius^2-(x-x_offset).^2)+y_offset;
circ2=-sqrt(radius^2-(x-x_offset) .^2)+y_offset;
                            %wektory wartosci Y okregu czesc gorna i dolna
plot(x,circ1,'k');hold on;
plot(x,circ2,'k');hold on;
                            %wykreslenie obydwu czesci okregu 
grid on;                    %wlaczenie linii siatki
axis equal;                 %rowne proporcje miedzy osiami XY

pzmap(L,M)                  %pzmap, znajduje i rysuje dla danej funkcji 
                            %zera oraz bieguny (zeros, poles)
[z,p,k]=tf2zpk(L,M);        %tf2zpk f. przejscia z czasu dyskretnego na 
                            %zera i bieguny (z-zeros, p-poles, k-gain);

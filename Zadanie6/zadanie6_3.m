%==========================================================================
%Projektowanie filtra metoda yule, sprawdzenie dzialania, obliczenie
%transformacji
%==========================================================================

clc
clear all
close all
format long e

% pierwszy zestaw danych 
F=[0 0.1 0.2 0.5 0.7 1];        %punkty graniczne czestotliwosci
M=[1 1 1 0 0 0];                %punkty graniczne amplitudy

% drugi zestaw danych 
% F=[0 0.1 0.7 1];
% M=[1 1 0 0];

N=[2,4,8];                      %rzedy filtrow

%% metoda Youle-walkera rzad 2,4 oraz 8
%================= rzad 2 filtra
[L1,M1]=yulewalk(N(1,1),F,M);   %filtr rekursywny yulewalk, filtr 2 rzedu 
                                %zwraca licznik L i mianownik M transmit.

figure(1);
freqz(L1,M1,128);               %wykres amplitudy i fazy(rozwiniety) filtra
hold on;                        %128- liczba punktow

[h1,w1]=freqz(L1,M1);           %h - wektor czestotliwosci, w- wektor omega
Mod1=20*log(abs(h1));           %modul [dB]
Fi_rad1=phase(h1);              %faza sygnalu [rad]
Fi_deg1=Fi_rad1*180/pi;         %faza sygnalu [deg] 
w_norm1=w1/pi;                  %czestotliwosc znormalizowana 

subplot(2,1,1)
plot(w_norm1,Mod1,'r')
title(['Odpowiedzi czestotliowsciowe filtra Yule-Walkera rzedu ',...
    num2str(N(1,3))]);

subplot(2,1,2)
plot(w_norm1,Fi_deg1,'r')
ylabel('Faza [deg]');
xlabel('czestotliwosc znormalizowana');
hold off

%================= rzad 4 filtra
[L2,M2]=yulewalk(N(1,2),F,M);

figure(2);
freqz(L2,M2,128);               %wykres amplitudy i fazy(rozwiniety) filtra
hold on;                        %128- liczba punktow

[h2,w2]=freqz(L2,M2);           %h - wektor czestotliwosci, w- wektor omega
Mod2=20*log(abs(h2));           %modul [dB]
Fi_rad2=phase(h2);              %faza sygnalu [rad]
Fi_deg2=Fi_rad2*180/pi;         %faza sygnalu [deg] 
w_norm2=w2/pi;                  %czestotliwosc znormalizowana 

subplot(2,1,1)
plot(w_norm2,Mod2,'r')
title(['Odpowiedzi czestotliowsciowe filtra Yule-Walkera rzedu ',...
    num2str(N(1,2))]);

subplot(2,1,2)
plot(w_norm2,Fi_deg2,'r')
ylabel('Faza [deg]');
xlabel('czestotliwosc znormalizowana');
hold off

%============== rzed 8 filtra
[L3,M3]=yulewalk(N(1,3),F,M);
figure(3);
freqz(L3,M3,128);               %wykres amplitudy i fazy(rozwiniety) filtra
hold on;                        %128- liczba punktow

[h3,w3]=freqz(L3,M3);           %h - wektor czestotliwosci, w- wektor omega
Mod3=20*log(abs(h3));           %modul [dB]
Fi_rad3=phase(h3);              %faza sygnalu [rad]
Fi_deg3=Fi_rad3*180/pi;         %faza sygnalu [deg] 
w_norm3=w3/pi;                  %czestotliwosc znormalizowana 

subplot(2,1,1)
plot(w_norm3,Mod3,'r')
title(['Odpowiedzi czestotliowsciowe filtra Yule-Walkera rzedu ',...
    num2str(N(1,3))]);

subplot(2,1,2)
plot(w_norm3,Fi_deg3,'r')
ylabel('Faza [deg]');
xlabel('czestotliwosc znormalizowana');
hold off

%% filtr projektowany poleceniem fir2
%================= rzad 2 filtra

b1=fir2(N(1,1),F,M);
                                %indeks f - dotyczy polecenia fir2
[hf1,wf1]=freqz(b1,1);          %h - wektor czestotliwosci, w- wektor omega  

Mod_f1=20*log(abs(hf1));        %modul [dB]
Fi_rad_f1=phase(hf1);           %faza sygnalu [rad]
Fi_deg_f1=Fi_rad_f1*180/pi;     %faza sygnalu [deg] 
w_norm_f1=wf1/pi;               %czestotliwosc znormalizowana 

%================ rzad 4 filtra
b2=fir2(N(1,2),F,M);
                                
[hf2,wf2]=freqz(b2,1);           

Mod_f2=20*log(abs(hf2));        %modul [dB]
Fi_rad_f2=phase(hf2);           %faza sygnalu [rad]
Fi_deg_f2=Fi_rad_f2*180/pi;     %faza sygnalu [deg] 
w_norm_f2=wf2/pi;               %czestotliwosc znormalizowana 


%================ rzad 8 filtra
b3=fir2(N(1,3),F,M);
                                
[hf3,wf3]=freqz(b3,1);           

Mod_f3=20*log(abs(hf3));        %modul [dB]
Fi_rad_f3=phase(hf3);           %faza sygnalu [rad]
Fi_deg_f3=Fi_rad_f3*180/pi;     %faza sygnalu [deg] 
w_norm_f3=wf3/pi;     

%================ rzad 128 filtra
b4=fir2(128,F,M);
                                
[hf4,wf4]=freqz(b4,1);           

Mod_f4=20*log(abs(hf4));        %modul [dB]
Fi_rad_f4=phase(hf4);           %faza sygnalu [rad]
Fi_deg_f4=Fi_rad_f4*180/pi;     %faza sygnalu [deg] 
w_norm_f4=wf4/pi;     

%% Porownanie odpowiedzi czestotliwosciowych filtrow fir2 i yule-walkera
% rzad 2 filtrow

figure(4)
subplot(2,1,1)
plot(w_norm_f1,Mod_f1);hold on;
plot(w_norm1,Mod1,'r');hold on;
title('Porowananie filtrow rzedu 2');
legend('Odpowiedz amplitudowo-czestotliwosciowa filtra fir2',...
    'Odpowiedz amplitudowo-czestotliwosciowa Yule-Walkera');
ylabel('Amplituda [dB]');
xlabel('czestotliwosc znormalizowana [-]');
grid on;


subplot(2,1,2)
plot(w_norm_f1,Fi_deg_f1);hold on;
plot(w_norm1,Fi_deg1,'r');hold off;
legend('Odpowiedz fazowo-czestotliwosciowa filtra fir2',...
    'Odpowiedz fazowo-czestotliwosciowa Yule-Walkera');
ylabel('Faza [deg]');
xlabel('czestotliwosc znormalizowana [-]');
grid on;

% rzad 4 filtrow

figure(5)
subplot(2,1,1)
plot(w_norm_f2,Mod_f2);hold on;
plot(w_norm2,Mod2,'r');hold on;
title('Porowananie filtrow rzedu 4');
legend('Odpowiedz amplitudowo-czestotliwosciowa filtra fir2',...
    'Odpowiedz amplitudowo-czestotliwosciowa Yule-Walkera');
ylabel('Amplituda [dB]');
xlabel('czestotliwosc znormalizowana [-]');
grid on;


subplot(2,1,2)
plot(w_norm_f2,Fi_deg_f2);hold on;
plot(w_norm2,Fi_deg2,'r');hold off;
legend('Odpowiedz fazowo-czestotliwosciowa filtra fir2',...
    'Odpowiedz fazowo-czestotliwosciowa Yule-Walkera');
ylabel('Faza [deg]');
xlabel('czestotliwosc znormalizowana [-]');
grid on;

% rzad 8 filtrow

figure(6)
subplot(2,1,1)
plot(w_norm_f3,Mod_f3);hold on;
plot(w_norm3,Mod3,'r');hold on;
title('Porowananie filtrow rzedu 8');
legend('Odpowiedz amplitudowo-czestotliwosciowa filtra fir2',...
    'Odpowiedz amplitudowo-czestotliwosciowa Yule-Walkera');
ylabel('Amplituda [dB]');
xlabel('czestotliwosc znormalizowana [-]');
grid on;


subplot(2,1,2)
plot(w_norm_f3,Fi_deg_f3);hold on;
plot(w_norm3,Fi_deg3,'r');hold off;
legend('Odpowiedz fazowo-czestotliwosciowa filtra fir2',...
    'Odpowiedz fazowo-czestotliwosciowa Yule-Walkera');
ylabel('Faza [deg]');
xlabel('czestotliwosc znormalizowana [-]');
grid on;

% rzad 8 youle-walkera i 128 fir2

figure(7)
subplot(2,1,1)
plot(w_norm_f4,Mod_f4);hold on;
plot(w_norm3,Mod3,'r');hold on;
title('Porowananie filtrow :rzad 8 youle-walkera i 128 fir2');
legend('Odpowiedz amplitudowo-czestotliwosciowa filtra fir2 rz. 128',...
    'Odpowiedz amplitudowo-czestotliwosciowa Yule-Walkera rz. 8');
ylabel('Amplituda [dB]');
xlabel('czestotliwosc znormalizowana [-]');
grid on;


subplot(2,1,2)
plot(w_norm_f4,Fi_deg_f4);hold on;
plot(w_norm3,Fi_deg3,'r');hold off;
legend('Odpowiedz fazowo-czestotliwosciowa filtra fir2 rz. 128',...
    'Odpowiedz fazowo-czestotliwosciowa Yule-Walkera rz. 8');
ylabel('Faza [deg]');
xlabel('czestotliwosc znormalizowana [-]');
grid on;
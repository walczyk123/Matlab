%==========================================================================
%generator sygnalow podstawowych
%==========================================================================

clc;
close all;
clear all;

A=1;                %amplituda 1
f=1;                %czestotliwosc sygnalu 1Hz
fs=1e3;             %czestotliwosc probkowania 0.001Hz
t=0:(1/fs):10;      %wektor czasu od 0 do 10 sek, krok 1/fs
n=[7,30,101];       %n(i)- ilosc skladowych sinusow we wzorze
T=1/f;              %okres sygnalu
omega=2*pi*f;       %obliczenie omegi

%======sygnal prostokatny bipolarny======
C=4*A/pi;           %stala we wzorze na trans. Fou. sygnalu prostok.
for i=1:length(n)   %petla z n sygnalami iloscia sygnalow
    y=0;
    for j=1:2:n(:,i)
        y=y+((1/j)*sin(j*omega*t));
    end
    y=y*C;          %przemnozenie otrzymanych wartosci przez stala
    Y(i,:)=y;       %obloczenie wartosci dyskretnych kazdego z n-sygnalow
end
figure(1)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['liczba skladowych sinus: ',num2str(n(1)),', prostokatny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['liczba skladowych sinus: ',num2str(n(2)),', prostokatny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['liczba skladowych sinus: ',num2str(n(3)),', prostokatny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');

%% ======sygnal prost. z wypelnieniem 1/2, unipolarny======
clear C Y y;
C=A/2;              %stala we wzorze na transf. Fouriera
D=2*(A/pi);         %druga stala we wzorze

for(i=1:3)
    y=0;
    for j=1:4:n(:,i)   %petla z krokiem 4, dodawanie co drugiego cosinusa
        y=y+((1/j)*cos(j*omega*t));
    end
    for k=3:4:n(:,i)   %petla z krokiem 4, odejmowanie co drugiego cosinusa
        y=y-((1/k)*cos(k*omega*t));
    end
    y=C+(y*D);      %obliczenie wzoru na sygnal
    Y(i,:)=y;       %wyznaczenie wartosci dyskretnych sygnalu
end
figure(2)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['liczba skladowych cosinus: ',num2str(n(1)),', prostokatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['liczba skladowych cosinus: ',num2str(n(2)),', prostokatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['liczba skladowych cosinus: ',num2str(n(3)),', prostokatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');

%% ======sygnal prost. z wypelnieniem dowolnym, unipolarny=====
clear C D Y y;
tau=.25;            %wypelnienie sygnalu

for i=1:length(n)
    y=0;
    for j=1:n(:,i)
        k=(pi*j*tau/T);     %stala we wzorze
        y=y+sin(k)*cos(j*omega*t)/k;
    end
    y=A*tau/T+2*A*tau*y/T;
    Y(i,:)=y;
end

figure(3)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['wypelnienie: ',num2str(tau),', liczba skladowych: ',num2str(n(1)),', prostokatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['wypelnienie: ',num2str(tau),', liczba skladowych: ',num2str(n(2)),', prostokatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['wypelnienie: ',num2str(tau),', liczba skladowych: ',num2str(n(3)),', prostokatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');

%% ======sygnal trojkatny bipolarny======
clear C Y y k tau;

C=8*A/(pi^2);       %stala we wzorze

for(i=1:3)
    y=0;
    for j=1:4:n(:,i)%petla z krokiem 4, dodawanie co drugiego sinusa
        y=y+((1/j^2)*sin(j*omega*t));
    end
    for k=3:4:n(:,i)%petla z krokiem 4, odejmowanie co drugiego sinusa
        y=y-((1/k^2)*sin(k*omega*t));
    end
    y=y*C;          %obliczenie wzoru na sygnal
    Y(i,:)=y;       %wyznaczenie wartosci dyskretnych sygnalu
end
figure(4)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['liczba skladowych: ',num2str(n(1)),', trojkatny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['liczba skladowych: ',num2str(n(2)),', trojkatny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['liczba skladowych: ',num2str(n(3)),', trojkatny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
%% ======sygnal trojkatny, piloksztaltny, bipolarny======
clear C Y y;
C=2*A/pi;

for(i=1:3)
    y=0;
    for j=1:2:n(:,i)%petla z krokiem 2, dodawanie co drugiego sinusa
        y=y+((1/j)*sin(j*omega*t));
    end
    for k=2:2:n(:,i)%petla z krokiem 2, odejmowanie co drugiego sinusa
        y=y-((1/k)*sin(k*omega*t));
    end
    y=y*C;          %obliczenie wzoru na sygnal
    Y(i,:)=y;       %wyznaczenie wartosci dyskretnych sygnalu
end

figure(5)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['liczba skladowych: ',num2str(n(1)),', trojkatny, piloksztaltny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['liczba skladowych: ',num2str(n(2)),', trojkatny, piloksztaltny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['liczba skladowych: ',num2str(n(3)),', trojkatny, piloksztaltny, bipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');

%% ======sygnal trojkatny unipolarny
clear C D Y y k j;
C=(4*A)/(pi^2);
D=A/2;

for i=1:3
    y=0;
    for j=1:1:n(:,i)
        k=(j-1)*2+1;
        y=y+((cos(k*omega*t))/(k^2));
    end
    y=D-(C*y);      %obliczenie wzoru na sygnal
    Y(i,:)=y;       %wyznaczenie wartosci dyskretnych sygnalu
end

figure(6)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['liczba skladowych: ',num2str(n(1)),', trojkatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['liczba skladowych: ',num2str(n(2)),', trojkatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['liczba skladowych: ',num2str(n(3)),', trojkatny, unipolarny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');

%% ======sygnal trojkatny unipolarny piloksztaltny
clear C D Y y k j;
C=(-A)/pi;
D=A/2;

for i=1:3
    y=0;
    for j=1:n(:,i)
        y=y+(1/j*sin(j*omega*t));
    end
    y=D+(y*C);      %obliczenie wzoru na sygnal
    Y(i,:)=y;       %wyznaczenie wartosci dyskretnych sygnalu
end

figure(7)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['liczba skladowych: ',num2str(n(1)),', trojkatny, unipolarny, piloksztaltny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['liczba skladowych: ',num2str(n(2)),', trojkatny, unipolarny, piloksztaltny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['liczba skladowych: ',num2str(n(3)),', trojkatny, unipolarny, piloksztaltny']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');

%% ======sygnal sinusoidalny wyprostowany dwupolowkowy
clear C D Y y k j;
C=(2*A)/pi;
D=-4*A/pi;

for i=1:3
    y=0;
    for j=1:n(:,i)
        y=y+(1/(4*(j^2)-1)*cos(2*j*omega*t));
    end
    y=(y*D)+C;      %obliczenie wzoru na sygnal
    Y(i,:)=y;       %wyznaczenie wartosci dyskretnych sygnalu
end

figure(8)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['liczba skladowych: ',num2str(n(1)),', sinusoidalny dwypolowkowy wyprostowany']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['liczba skladowych: ',num2str(n(2)),', sinusoidalny dwypolowkowy wyprostowany']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['liczba skladowych: ',num2str(n(3)),', sinusoidalny dwypolowkowy wyprostowany']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');

%% ======sygnal sinusoidalny wyprostowany jednopolowkowy
clear C D Y y k j;
C=A/pi;
D=A/2;
E=-2*A/pi;

for i=1:3
    y=0;
    for j=1:n(:,i)
        y=y+(1/(4*(j^2)-1)*cos(2*j*omega*t));
    end
    y=y*E+sin(omega*t)*D+C;      %obliczenie wzoru na sygnal
    Y(i,:)=y;       %wyznaczenie wartosci dyskretnych sygnalu
end

figure(9)           %nowe okno wykresu
subplot(3,1,1);     %wykres na pierwszej pozycji z trzech
plot(t,Y(1,:));     %wykreslenie przebiegu pierwszego sygnalu
title(['liczba skladowych: ',num2str(n(1)),', sinusoidalny jednopolowkowy wyprostowany']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,2);     %wykres na drugiej pozycji
plot(t,Y(2,:));     %wykreslenie przebiegu drugiego sygnalu
title(['liczba skladowych: ',num2str(n(2)),', sinusoidalny jednopolowkowy wyprostowany']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
subplot(3,1,3);     %wykres na ostatniej pozycji
plot(t,Y(3,:));     %wykreslenie przebiegu trzeciego sygnalu
title(['liczba skladowych: ',num2str(n(3)),', sinusoidalny jednopolowkowy wyprostowany']);
xlabel('czas [s]');
ylabel('amplituda sygnalu');
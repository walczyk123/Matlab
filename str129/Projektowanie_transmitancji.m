%==========================================================================
%1. Projekt filtra pasmowoprzepustowego wpass1=9.5rd, wpass2=10.5rd
%2. Znajdowanie zer i biegunow transmitancj
%3. Projekt filtra gornoprzepustowego
% Jest to  zmodyfikowana wersja programu z ksiazki, wszystkie trzy
% przyklady wyswietlaja sie w postaci okien nalozonych na siebie, aby
% ulatwic odczytanie pierwszy przyklad to pierwsza kolumna, drugi to druga,
% itd. Natomiast kazdy wykres ma tytul do ktorego to przykladu sie odnosi, 
% folder z programem zawiera zrzut ekranu wygladu okien
%==========================================================================
clear all;
close all;
clc;
for i=1:3
    przyklad=i;                     %wybor przykladu
    
    if przyklad==1
        z1=5;
        z2=15;                      %zera na osi urojonej    
        z=1j*[-z2, -z1, z1,z2];     %zapis zer w postacii wektora
        odl=0.5;
        p1=9.5;                     %bieguny przy osi urojonej
        p2=10.5;
        p=[-odl-1j*p2,-odl-1j*p1, odl+1j*p1, odl+1j*p2];
                                    %zapis biegonow w postaci wektora
        wmax=20;                    %maksymalna pulsacja
        tmax=20;                    %maksymalny czas obserwacji
    end

    if przyklad==2
        b=[0.66667 0 1];            %wspolczynniki licznika transmitancji
        a=[4.0001 5.0081 3.1650 1]; %wspolczynniki mianownika transmitancji
        [z,p,wzm]=tf2zp(b,a);       %funkcja na podstawie licznika i mianownika
                                    %transmitancji podaje zera, bieguny, wzmoc.
                                    %z-zeros,p-poles,wzm-gains
        z=z';                       %transformacja wektorow na poziome
        p=p';
        wmax=5;                     %maksymalna pulsacja
        tmax=20;                    %maksymalny czas obserwacji                            
    end

    if przyklad==3
        z1=0;
        z2=0+1j*1;
        z3=0-1j*1;
        z4=0+1j*2;                  %zera na osi urojonej
        z5=0-1j*2;
        z6=0+1j*3;
        z7=0-1j*3;
        z=[z1 z2 z3 z4 z5 z6 z7];   %wektor zer

        p1=-1;
        p2=-1+1j*1;
        p3=-1-1j*1;
        p4=-1+1j*2;                 %bieguny w poblizu osi urojonej
        p5=-1-1j*2;
        p6=-1+1j*3;
        p7=-1-1j*3;
        p=[p1 p2 p3 p4 p5 p6 p7];   %wektor biegunow

        wmax=20;                    %maksymalna pulsacja
        tmax=5;                     %maksymalny czas obserwacji                            
    end


    f=figure('Position',[1+500*(i-1),400,500,500]);
    movegui(f);
    
    plot(real(z),imag(z),'or',real(p),imag(p),'xb');
    grid;
    title(['Zera o i bieguny x, przyklad ',num2str(i)]);
    xlabel('Czesc rzeczywista');
    ylabel('Czesc urojona [rad/s]');
    
    w = 0 : 0.01 : wmax;        %wybrane pulsacje widma
    [b,a] = zp2tf(z',p',1);     %zera, bieguny
    H = freqs(b,a,w);           %widmo transmitancji 
    Hm = abs(H);
    HmdB = 20*log10(Hm);        %modul transmitancji
    Hf = angle(H);              %faza transmitancj
    Hfu = unwrap(Hf);           %faza transmitancj rozwinieta
    

    f=figure('Position',[1+500*(i-1),300,500,500]);
    movegui(f);
    plot(w,Hm);
    grid;
    title(['Ch-ka amplitudowa dla przykladu ',num2str(i)]);
    xlabel('Czestosc [rad/s]');
    

    f=figure('Position',[1+500*(i-1),200,500,500]);
    movegui(f);
    plot(w,HmdB);
    grid;
    title(['Ch-ka amplitudowa [dB], dla przykladu ',num2str(i)]);
    xlabel('Czestosc [rad/s]');
    

    f=figure('Position',[1+500*(i-1),100,500,500]);
    movegui(f);
    plot(w,Hf);
    grid;
    title(['Ch-ka fazowa, dla przykladu ',num2str(i)]);
    xlabel('Czestosc [rad/s]');
    ylabel('[rad]');
    

    f=figure('Position',[1+500*(i-1),0,500,500]);
    movegui(f);
    plot(w,Hfu);
    grid;
    title(['Ch-ka fazowa rozwinieta, dla przykladu ',num2str(i)]);
    xlabel('Czestosc [rad/s]');
    ylabel('[rad]');
    
end
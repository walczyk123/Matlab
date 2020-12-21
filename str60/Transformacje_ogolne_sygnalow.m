%==========================================================================
%1. Transformaty ortogonalne sygnalow
%-ksztalt dyskretnych baz fouriera, cosinusowej sinusowejm Hadamarda,
%Walsha
%-dopasowanie bazy
%==========================================================================
clc;
clear all;
close all;

N=8;                        %liczba funkcji bazowych
n=0:N-1;                    %indeksy wszystkich probek
NN=2*N;                     %zmienna pomocnicza
j=2;

f=1/sqrt(N);                %wsp. normalizujacy transformacje Fouriera
c=[sqrt(1/N) sqrt(2/N)*ones(1,N-1)];
                            %wsp. normalizujacy transformacje kosinusowa
s=sqrt(2/(N+1));            %wsp. normalizujacy transformacje sinusowa   

for i=0:N-1                 %dane do teorii i wzorow znajduja sie na str.52
                            %jak liczy sie bazy dyskretne
    bf(i+1,n+1)=f*exp(j*2*pi/N*i*n);
                            %transformacja fouriera (str.51 wzor  2.27)
    bc(i+1,n+1)=c(i+1)*cos(pi*i*(2*(n+1))/NN);
                            %transformacja kosinusowa (str.52 wzor  2.76)
    bs(i+1,n+1)=s*sin(pi*(i+1)*(n+1)/(N+1));
                            %transformacja sinusowa (str.52 wzor  2.77)
end

%===== ksztalt f. bazowych dla transformacji Hadamarda ====================
%opis i wzory do dyskretnych baz hamarada na stronie 52, wzor 2.79


m=log2(N);                  %zmienne pomocnicze
c=sqrt(1/N);
for i=0:N-1
    k=i;
    for j=0:m-1
        kj(j+1)=rem(k,2);   %rem - reszta pozostala po dzieleniu
        k=floor(k/2);       %floor - zaokraglenie liczby w dol
    end
    for n=0:N-1
        nn=n;
        for j=0:m-1
            nj(j+1)=rem(nn,2);
            nn=floor(nn/2);
        end
        bHD(i+1,n+1)=c*(-1)^sum(kj.*nj);
    end
end

%===== ksztalt f. bazowych dla transformacji Hadara =======================
%opis i wzory do dyskretnych baz Haara na stronie 54, wzor 2.80 (dla 3
%przypadkow)

c=sqrt(1/N);
bHR(1,1:N)=c*ones(1,N);

for i=1:N-1
    p=0;
    while(i+1>2^p)
        p=p+1;
    end
    p=p-1;
    q=i-2^p+1;
    for n=0:N-1
        x=n/N;
        if(((q-1)/2^p<=x)&(x<(q-1/2)/2^p))bHR(i+1,m+1)=c*2^(p/2);
        elseif(((q-1/2)/2^p<=x)&(x<q/2^p))bHR(i+1,n+1)=-c*2^(p/2);
        else bHR(i+1,n+1)=0;
        end
    end
end

%========= sprawdzenie ortonormalności f. bazowych ========================

for i=1:N
    Tf(i,1:N)=bf(i,1:N);        %Fouriera
    Tc(i,1:N)=bc(i,1:N);        %kosinusow
    Ts(i,1:N)=bs(i,1:N);        %sinusow
    THD(i,1:N)=bHD(i,1:N);      %Hadamarda
    THR(i,1:N)=bHR(i,1:N);      %Haara
end

I1=Tf*Tf';
I2=Tc*Tc';
I3=Ts*Ts';
I4=THD*THD';
I5=THR*THR';

%======= dekompozycja sygnalow ============================================

kk = 2;       % testowy „indeks” częstotliwości, np. 1.35, 2, 2.5, 3
fi = 0;       % przesunięcie fazowe 0, pi/8, pi/4, pi/2
n = 0 : N-1;


x1 = cos( (2*pi/N)*kk*n + fi );           
                                % cz. rzeczywista bazy fourierowskiej
x2 = cos( pi*kk*(2*n+1)/NN + fi );        
                                % wektor bazy kosinusowej
x3 = sin( pi*(kk+1)*(n+1)/(N+1) + fi );   
                                % wektor bazy sinusowej
x4 = cos( (2*pi/N)*2*n + fi ) + cos( (2*pi/N)*4*n + fi );
x5 = [ ones(1,N/2) zeros(1,N/2) ];
x6 = [ -ones(1,N/4) ones(1,N/2) -ones(1,N/4) ];

x=x6;                           %wybor sygnalu do dekompozycji
T=THR;                          %wybor transformacji

a=T*x';                         %analiza w zapisie macierzowym
y=(T'*a)';                      %synteza w zapisie macierzowym (pomiomo)

figure(1)
subplot(2,2,1);
stem(n,x,'filled','-k');        %wykres danych dyskretnych (punkty nie sa
                                %ze soba polaczone, linie od punktu do OX)
axis tight;
title('Analizowany sygnal x(n)');
xlabel('Probka');

subplot(2,2,2);
stem(n,real(a),'filled','-k');
axis tight;
title('Wspolczynnik dekompozycji alfa(k)');
xlabel('Probka')

subplot(2,2,3);
stem(n,y,'filled','-k');
axis tight;
title('Sygnal zsyntezoway x(l)');
xlabel('Probka');

subplot(2,2,4);
stem(n,y-x,'filled','-k');
axis tight;
title('Blad syntezy 1: y(l)-x(l)');
xlabel('Probka');

%==================Analiza i synteza w zapisie niemacierzowym==============
y=zeros(1,N);
for k = 0 : N-1                             % analiza- obliczanie wsp.
    a(k+1)  = sum( x .* conj(T(k+1,1:N)) );  
end
for k = 0 : N-1                             %synteza- odtworzenie sygnalu
    y  = y  +  a(k+1) * T(k+1,1:N); 
end
figure(2)
stem(n,y-x,'filled','-k');
axis tight;
title('Blad syntezy 2: y(l)-x(l)');
xlabel('Probka');
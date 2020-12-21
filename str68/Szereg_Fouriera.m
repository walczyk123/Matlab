%==========================================================================
% Szereg Fouriera - aproksymacja wybranych przebiegow czasowych 
%==========================================================================

clear all;
clc;
close all;

T=1;                    %okres 1s
N=1000;                 %liczba probek na okres
dt=T/N;                 %dlugosc jednej probki
t=dt*(0:N-1);           %wektor czasu
A=1;                    %amplituda sygnalu
NF=30;                  %liczba wspolczynnikow szeregu fouriera <N/2 (<500)
f0=1/T;                 %bazowa czestotliwosc szeregu Fouriera

nr_syg=2;               %ktory sygnal ma byc sprawdzany

if(nr_syg==1) 
    x=[0 A*ones(1,N/2-1) 0 -A*ones(1,N/2-1)];
                        %sygnal prostokatny- do polowy przebieg o
                        %wartisciach dodatnich, w drugiej polowie, sygnal 
                        %przyjmuje wartosci ujemne, pomiedzy nimi 0
end
if (nr_syg==2) 
    x=[A*ones(1,N/4) 0 -A*ones(1,N/2-1) 0 A*ones(1,N/4-1)];
                        %sygnal prostokatny, pierwsza i 4 cwiartka
                        %dodatnie, 2 i 3 cwiartka dlugosci, wart. ujemne
end
if (nr_syg==3) 
    x=[A*ones(1,N/8) 0 -A*ones(1,5*N/8-1) 0 A*ones(1,2*N/8-1)];
                        %sygnal prostokatny, inne czesci dodatnie i ujemne
end
if (nr_syg==4) 
    x=(A/T)*t;
                        %sygnal narastajacy od 0 do A w calym przedziale t
end
if (nr_syg==5) 
    x=[(2*A/T)*t(1:N/2+1) (2*A/T)*t(N/2:-1:2)];
                        %sygnal narastajacy w przedziale (0 t/2) i gasnacy
                        %w przedziale czasu (t/2 t)
end
if (nr_syg==6) 
    x=sin(2*pi*t/(T));
                        %sygnal sinusoidalny ( 1 okres w czasie t)
end

figure(1);
plot(t,x);
title(['Rozpatrywany sygnal x',num2str(nr_syg)]);


for i=0:NF-1
    ci=cos(2*pi*i*f0*t);
    si=sin(2*pi*i*f0*t);
    
    a(i+1)=sum(x.*ci)/N;
    b(i+1)=sum(x.*si)/N;
end

f=(0:(NF-1))*f0;

figure(4);
subplot(2,1,1);
stem(f,a,'filled');
xlabel('[Hz]');
title('Wspolczynniki cosinus');

subplot(2,1,2);
stem(f,b,'filled');
xlabel('[Hz]');
title('Wspolczynniki sinus')


%====== porownanie z teoretycznymi wspolczynnikami ========================
if(nr_syg==2)
    at=[];                  %utworzenie pustych wektorow wspolczynnikow a,b
    bt=[];
    for i=1:2:NF
        at=[at 0 0];
        bt=[bt 0 (2*A)/(pi*i)];
    end
    subplot(2,1,1);
    plot(f,a-at(1:NF));
    grid;
    xlabel('[Hz]');
    title('Roznica cosinusow');
    
    subplot(2,1,2);
    plot(f,b-bt(1:NF));
    grid; xlabel('[Hz]');
    title('Roznica sinisow');
end    

%====== porownanie z dyskretna transfotmacja Fouriera (DFT)================

X = fft(x,N)/N;
X = conj(X);            % funkcje bazowe exp(-jwt) a nie exp(j*wt)
                        % czyli dla sygnałów rzecz. x mamy sprzezenie
subplot(2,1,1);
plot( f, a-real(X(1:NF)) );
grid; title('Różnica miedzy DFT a cosinus');

subplot(2,1,2);
plot( f, b-imag(X(1:NF)) );
grid;
title('Różnica miedzy DFT a sinus')


% Synteza sygnału ze współczynników rozwinięcia

subplot(1,1,1);
a(1)=a(1)/2;
y=zeros(1,N);
for i=0:NF-1
    y = y + 2*a(i+1)*cos(i*2*pi*f0*t) + 2*b(i+1)*sin(i*2*pi*f0*t);
    plot(t,y);
    grid;
    title(['Suma i pierwszych funkcji bazowych, i=',num2str(NF-1)]);

end
figure(5);
plot(t,y); 
grid;
title('Całkowity sygnał zsyntezowany');
xlabel('czas [s]');

figure(6)
plot(t,y-x);
grid;
title('Sygnal bledu');
xlabel('czas [s]');


%========== zbiorcze porownanie syg. oryg., zsyntezowanego i bledu ========
figure(7)
subplot(3,1,1);
plot(t,x);
title(['Rozpatrywany sygnal x',num2str(nr_syg)]);
xlabel('czas [s]');

subplot(3,1,2)
plot(t,y); 
grid;
title('Całkowity sygnał zsyntezowany');
xlabel('czas [s]');


subplot(3,1,3);
plot(t,y-x);
grid;
title('Sygnal bledu');
xlabel('czas [s]');
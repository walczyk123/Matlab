%==========================================================================
% Twierdzenie o probkowaniu:
%1.Jezeli maksymalna czestotliwosc sygnalu jest 2x wieksza niz
%czestotliwosc probkowania to z sygnalu mozna dokladnie odtworzyc sygnal
%analogowy
%2. Przejscie z czestotliwosci wiekszej (fps) do mniejszej (fpn) i powrot,
%czyli odtworzenie sygnalu fps/fpn=K, fpn=fps/K>2, K-liczba calkowita
%==========================================================================

clear all;
close all;
clc;

fx=1;                   %czestotliwosc sygnalu 1[Hz]
fps=100;                %czestotliwosc probkowania [Hz] (wieksza)
N=200;                  %liczba probek sygnalu probkowanego z czestot. fps
K=10;                   %ile razy zmniejszyc czestotliwosc probkowania

%=========== wygenerowanie sygnalu z czestotliwoscia fps ==================

dts=1/fps;              %stary okres probkowania (dlugosc 1 probki)
ts=dts*(0:N-1);         %wektor czasu dla fps
xs=sin(2*pi*fx*ts);     %przebieg sygnalu sin, probkowanego z cz. fps

figure(1);
plot(ts,xs,'b');
hold on;
plot(ts,xs,'ro');
title('Sygnal sprobkowany');
xlabel('Czas (s)');
legend('Sygnal probkowany','Sygnal sprobkowany (dyskretny)');

%=========== przejscie na nowa czestotliwosc (z fps na fpn) ===============

fpn=fps/K;              %nowa czestotliwosc probkowania

xn=xs(1:K:length(xs));  %nowy wektor probek, w stosunku do xs, pomijane sa
                        %probki, natomiast przepisane zostaja tylko te
                        %oddalone miedzy soba o wielkosc K
M=length(xn);           %dlugosc nowego wektora probek
dtn=K*dts;              %dlugosc nowego okresu, jest K razy wiekszy niz dts
tn=(0:(M-1))*dtn;       %nowy wektor czasu na podstawie nowego okresu

figure(2);
plot(ts,xs,'r',tn,xn,'b');
title('Porownanie sygnalow sprobkowanych w fps i fpn');
xlabel('Czas (s)');
legend('Sygnal sprobkowany z czestotliwoscia fps',...
    'Sygnal sprobkowany z czestotliwoscia fpn');
axis([0 2 -1.1 1.1]);

figure(3);
plot(ts,xs,'ro',tn,xn,'bx');
title('Porownanie sygnalow sprobkowanych w fps i fpn');
xlabel('Czas (s)');
legend('Sygnal sprobkowany z czestotliwoscia fps',...
    'Sygnal sprobkowany z czestotliwoscia fpn');
axis([0 2 -1.1 1.1]);

%% =========== powrot z mniejszej czestotliwosci na wieksza ===============
%=========== funkcja aproksymacja sinc

t=(-(N-1):1:(N-1))*dts; % czas trwania funkcji aproksymujacej
f=1/(2*dtn);            % czestotliwosc zer w funkcji aproksymujacej
fa=sin(2*pi*f*t)./(2*pi*f*t);
                        %funkcja aproksymujaca
fa(N)=1;                %pierwsza watrosc w 0, 1 unika problemu 0/0
tz=[-fliplr(tn) tn(2:M)]; 
                        % odwrocenie wektora tn i dodanie tn 
z=[zeros(1,M-1) 1 zeros(1,M-1)];
                        %wektor zer i 1 w punkcie 0
figure(4);                       
plot(t,fa,'b',tz,z,'o');
grid;
title('Sinc - funkcja aproksymująca');
legend('funkcja aproksymujaca sinc','wektor tz');

%=========== aproksymacja 

y = zeros(1,N);
ty = (0:(N-1))*dts;     %nowy wektor czasu (dla czestotliwosci fps)
figure(5); 
for i=1:M
    fa1=fa( N-(i-1)*K:(2*N-1)-(i-1)*K);
    y1=xn(i)*fa1;
    y=y+y1;
    subplot(311);
    plot(ty,fa1);
    grid;
    title('Kolejna funkcja aproksymująca');
    subplot(312);
    plot(ty,y1);
    grid;
    title('Kolejny składnik sumy');
    subplot(313);
    plot(ty,y);
    grid;
    title('Suma');
    pause(0.5);         %pauza na pol sekundy aby zobaczyc wykres 
end    

figure(6)
subplot(2,1,1);
plot(ty,y,'b');
grid;
title('Odtworzony sygnal')

subplot(2,1,2);
plot(ty,xs(1:N)-y(1:N),'b');
grid;
title('Roznica miedzy sygnalami pierwotnym i odtworzonym');
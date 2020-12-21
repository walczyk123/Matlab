%==========================================================================
% Projektowanie rekursywnych filtrow cyfrowych metoda zer i biegunow
%==========================================================================

clear all;
clc;
close all;

projekt=1;              %wybor filtra 1-LP, 2-BP
filtr=3;                %filtracja  1-matlab, 2-bufory przesuwne, 3-kolowe
odpimp=0;               %odpowiedz impulsowa 0- nie pokazuj, 1-pokaz
fpr=1000;               %czestotliwosc probkowania w Hz

%=================== typ filtra ===========================================
if projekt==1                    
    fz=[50];            %czestotliwosc zer  [Hz]
    fp=[10];            %czestotliwosc biegunow [Hz]
    Rz=[1];             %promienie zer
    Rp=[0.95];          %promienie biegunow   
    fmax=100;
    df=0.1;             %parametry obliczanego widma Fouriera  
end

if (projekt==2)                      
    fz=[50 100 150 350 400 450]; 
                        %czestotliwosc zer  [Hz]
    fp=[200 250 300];   %czestotliwosc biegunow [Hz]
    Rz=[1 1 1 1 1 1];   %promienie zer   
    Rp=[0.9 0.65 0.9];  %promienie biegunow   
    fmax=500;
    df=1;               %parametry obliczanego widma Fouriera
end

%================= obliczenie zer i biegunow transmitancji ================

fi_z=2*pi*(fz/fpr);     %katy zer w pasmie zaporowym
fi_p=2*pi*(fp/fpr);     %katy biegunow w pasmie przepuszczania
z=Rz.*exp(1j*fi_z);     %zera
p=Rp.*exp(1j*fi_p);     %bieguny
z=[z conj(z)];          %dodanie sprzezonych zer
p=[p conj(p)];          %dodanie sprzezonych biegunow

%================= wykres zer i biegunow ==================================
NP=1000;                %liczba probek
fi=2*pi*(0:1:NP-1)/NP;  %wektor katow
s=sin(fi);
c=cos(fi);              %okrag zaznaczajacy promien

figure(1);
plot(s,c,'-k',real(z),imag(z),'or',real(p),imag(p),'xb');
title('zera i bieguny'); 
grid;
axis equal;
xlabel('Rzeczywiste');
ylabel('Urojone');
legend('Promien','Zera','Bieguny')

%============ wspolczynniki transmitancji zp->ba ==========================
wzm=1;
[b,a]=zp2tf(z',p',wzm); %wyznaczenie mianownika i licznika z zer i biegunow

%=========== charakterystyka czestotliwosciowa H(f) =======================
f=0:df:fmax;            %wektor czestotliwosci
w=2*pi*f;
wn=2*pi*f/fpr;
H=freqz(b,a,wn);
Habs=abs(H);
HdB=20*log10(Habs);
Hfa=unwrap(angle(H));

figure(2);
subplot(311);
plot(f,Habs);
grid;
title('Modul |H(f)|');
xlabel('Czastotliwosc [Hz]');

subplot(312);
plot(f,HdB);
grid;
title('Modul |H(f)| dB');
xlabel('Czastotliwosc [Hz]');

subplot(313);
plot(f,Hfa);
grid;
title('Faza H(f)');
xlabel('Czastotliwosc [Hz]');
ylabel('[rad]');


%=================== generowanie sygnalow testowych =======================

Nx=1024;                %liczba probek
n=0:Nx-1;               %wektor probek
dt=1/fpr;               %Okres trwania probki
t=dt*n;                 %czas

f1=10;                  %czestotliwosc 1 10 Hz
f2=50;                  %czestotliwosc 2 50 Hz
f3=250;                 %czestotliwosc 3 250 Hz

x1=sin(2*pi*f1*t);      %sygnal 1
x2=sin(2*pi*f2*t);      %sygnal 2
x3=sin(2*pi*f3*t);      %sygnal 3

if (projekt==1) 
    x=x1+x2; 
else
    x=x1+x2+x3;
end

if (odpimp==1) 
    x=zeros(1,Nx);
    x(1)=1;
end

%================== filtracja sygnalu x(n)->y(n)===========================
if (filtr==1) 
    y=filter(b,a,x);    %funkcja matlaba
end      

if (filtr==2) 
    y=filterBP(b,a,x);  %funkcja wykorzytujaca bufory przesuwne (str 266)
end

if (filtr==3) 
    y = filterBK(b,a,x);%funkcja wykorzytujaca bufory kolowe (str 267)
end 

%===================== wyniki =============================================

figure(3);
subplot(211);
plot(t,x);
grid;
axis tight;
title('Wejscie x(n)');

subplot(212);
plot(t,y);
grid;
axis tight;
title('Wyjscie y(n)');
xlabel('Nr próbki n');

n=Nx/2+1:Nx;
X = freqz(x(n),1,wn)/(Nx/4);
Y = freqz(y(n),1,wn)/(Nx/4);
X = abs(X); 
Y = abs(Y);

figure(4);
subplot(211);
plot(f,X);
grid;
title('Wejscie X(f)');

subplot(212);
plot(f,Y);
grid;
title('Wyjscie Y(f)');
xlabel('Czestotliwosc [Hz]'); 



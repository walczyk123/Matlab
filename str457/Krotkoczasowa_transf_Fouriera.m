%==========================================================================
% Krotkoczasowa transformacja Fouriera
%==========================================================================

clear all;
close all;
clc;


M=32;                       %polowa dlugosci okna 
N=2*M-1;                    %cala dlugosc okna
Nx=128;                     %dlugosc sygnalu testowego

fpr=128;                    %czestotliwosc probkowania
f0=0;
df=32;
dfm=12;
fn=16;
fm=3;
dt=1/fpr;                   %okres trwania probki
n=0:Nx-1;                   %wektor probek
t=n*dt;                     %wektor czasu

x=sin(2*pi*(fn*t+(dfm/(2*pi*fm))*sin(2*pi*fm*t)));
                            %sygnal testowy
%============= analiza TF =================================================
x=hilbert(x);
w=hanning(2*M-1)';
for n=M:Nx-M+1 
    xx=x(n-(M-1):1:n+(M-1));
    xx=xx.*w;
    xx=[xx 0];
    X(:,n-M+1)=fftshift(abs(fft(xx))');
end

t=t(M:Nx-M+1);
f=fpr/(2*M)*(-M:M-1);

subplot(2,1,1)
mesh(t,f,X);
view(-40,70);
axis tight; 
xlabel('Czas [s]');
ylabel('Czestotliwosc [Hz]');

subplot(2,1,2)
imagesc(t,f,X); 
xlabel('Czas [s]'); 
ylabel('Czestotliwosc [Hz]'); 
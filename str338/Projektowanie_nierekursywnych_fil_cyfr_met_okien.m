%==========================================================================
% Projektowanie nierekursywnych filtrow cyfrowych metoda okien (Kaissera) 
%==========================================================================
close all;
clear all;
clc;

fpr=1000;                   %czestotliwosc probkowania

fd1=150;                    %czestotliwosc dolna 1
fd2=200;                    %czastotliwosc dolna 2
fg1=300;                    %czestotliwosc gorna 1
fg2=350;                    %czestotliwosc gorna 2

dp=1e-3;                    %oscylacja w pasmie przepustowym
ds=1e-4;                    %oscylacja w pasmie zaporowym

typ='lp';                   %lp, hp, bp, bs

%==================== parametry okna ======================================

if typ=='lp'
    df=fd2-fd1;
    fc=((fd1+fd2)/2)/fpr;
    wc=2*pi*fc;
end

if typ=='hp'
    df=fg2-fg1;
    fc=((fg1+fg2)/2)/fpr;
    wc=2*pi*fc;
end

if (typ=='bp') 
    df1=fd2-fd1;
    df2=fg2-fg1;
    df=min(df1,df2);
    f1=(fd1+(df/2))/fpr;
    f2=(fg2-(df/2))/fpr;
    w1=2*pi*f1;
    w2=2*pi*f2;
end

if (typ=='bs') 
    df1=fd2-fd1;
    df2=fg2-fg1;
    df=min(df1,df2);
    f1=(fd1+(df/2))/fpr;
    f2=(fg2-(df/2))/fpr;
    w1=2*pi*f1;
    w2=2*pi*f2;
end

d=min(dp,ds);
A=-20*log10(d);

if (A>=50)
    beta=0.1102*(A-8.7);
end

if (A>21 && A<50)
    beta=(0.5842*(A-21)^0.4)+0.07886*(A-21);
end

if (A<=21)
    beta=0;
end

if (A>21) 
    D=(A-7.95)/14.36;
end

if (A<=21)
    D=0.922;
end

N=(D*fpr/df)+1;
N=ceil(N);
if(rem(N,2)==0) 
    N=N+1;
end

M=(N-1)/2;
m=1:M;
n=1:N;
 
%============= generowanie okna ===========================================
w=besseli(0, beta * sqrt(1-((n-1)-M).^2/M^2))/besseli(0,beta);
                            %funkcja bessela
figure(1);
plot(n,w);
title('Funkcja okna');
grid; 
 
%============= generowanie odpowiedzi impulsowej=========================== 
 
if (typ=='lp')              %filtr LP
    h=2*fc*sin(wc*m)./(wc*m);
    h=[ fliplr(h) 2*fc h];
end   

if (typ=='hp')              %filtr HP   
    h=-2*fc*sin(wc*m)./(wc*m);
    h=[ fliplr(h) 1-2*fc h];
end

if (typ=='bp')              %filtr BP     
    h=2*f2*sin(w2*m)./(w2*m)-2*f1*sin(w1*m)./(w1*m);
    h=[ fliplr(h) 2*(f2-f1) h]; 
end

if (typ=='bs')              %filtr BS     
    h=2*f1*sin(w1*m)./(w1*m)-2*f2*sin(w2*m)./(w2*m);
    h=[fliplr(h) 1+2*(f1-f2) h];  
end

figure(2);
plot(n,h);
title('Odpowiedz impulsowa filtra');
grid;
 
%======= przemnozenie odpowiedzi impulsowej przez funkcje okna ============
hw=h.*w;
figure(3);
plot(n,hw);
title('Odpowiedz impulsowa filtra z oknem');
grid;
 
%=============== Charakterystyka czestotliwosciowa ========================
NF=1000;                        %liczba probek
fmin=0;                         %minimalna czestotliwosc
fmax=fpr/2;                     %maksymalna czestot. 2x mniejsza od fpr

f=fmin:(fmax-fmin)/(NF-1):fmax; %czestotliwosc  
w=2*pi*f/fpr;                   %pulsacja  
HW=freqz(hw,1,w);               %widmo Fouriera 

figure(4);
subplot(3,1,1);
plot(f,abs(HW));
grid;
title('Modul');
xlabel('Czestotliwosc [Hz]');

subplot(3,1,2);
plot(f,20*log10(abs(HW)));
grid;
title('Modul dB');
xlabel('Czestotliwosc [Hz]');
ylabel('dB');

subplot(3,1,3);
plot(f,unwrap(angle(HW)));
grid;
title('Wykres rozwiniety fazy');
xlabel('Czestotliwosc [Hz]');
ylabel('[rad]'); 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 


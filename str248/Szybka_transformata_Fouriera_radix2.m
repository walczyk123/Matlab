%==========================================================================
% Algorytm szybkiej transformacji Fouriera FFT typu radix-2 DIT
%==========================================================================
clear all;
close all;
clc;

N=8;                    %liczba probek sygnalu  wymagane N=2^p
x=0:N-1;                %wartosci probek  
typBitReverse=2;        %algorytm przestawiania probek (1-wolna, 2-szybka)
typFFT=2;               %typ petli FFT (1-wolna, 2-szybka)

xc = x;                 %kopia oryginalnego sygnalu x

%% =========== Przestawianie kolejnosci probek ============================
%============= wolne ======================================================

if(typBitReverse==1)
    MSB=log2(N);        %liczba bitow probek
    for n=0:N-1         %petla rozpatrujaca kolejne probki 
        ncopy=n;        %kopia obecnego numeru probki
        nr=0;           %inicjalizacja nowego numeru probki
        for m=1:MSB     %przejscie po wszystkich probkach
            if (rem(n,2)==0)
                        %1)dzielenie probek - indeksy parzyste, nieparzyste
                n=n/2;       
            else
                nr=nr+2^(MSB-m);
                n=(n-1)/2;%po odjeciu jedynki - przesuwa sie w prawo
            end
        end
        y(nr+1)=x(ncopy+1);
    end
    x=y;                %nowe podstawienie otrzymanego wyniku
end

%============= szybkie ====================================================

if(typBitReverse==2)
    a=1;
    for b=1:N-1
        if b<a
            T=x(a);
            x(a)=x(b);      %zamiana wartosci x(a) z x(b), zmienna pomoc. T
            x(b)=T;
        end
        c=N/2;
        while(c<a)
            a=a-c;
            c=c/2;
        end
        a=a+c;
    end
end

%% ============ szybka transformata Fouriera FFT ==========================
%============= wolne ======================================================


 if typFFT==1
    for e=1:log2(N)
        SM=2^(e-1);         %szerokosc motylka
        LB=N/(2^e);         %liczba blokow
        LMB=2^(e-1);        %liczba motylkow w jednym bloku
        OMB=2^e;            %odleglosci pomiedzy blokami
        W=exp(-1j*2*pi/2^e);%podstawa bazy Fouriera
        for b=1:LB          %przejscie przez kolejne bloki
            for m=1:LMB     %przejscie przez kolejne motylki
                g=(b-1)*OMB+m;  
                            %indeks gornej probki motylka
                d=g+SM;     %indeks dolnej probki motylka (gorna+szerokosc)
                
                xgora=x(g); %kopia gornej probki
                xdol=x(d)*W^(m-1);
                            %korekta dolnej probki
                x(g)=xgora+xdol;
                x(d)=xgora-xdol;
                            %nowe probki dolne i gorne (po korekcji dolnej)
            end
        end
    end
 end
 
 %============= szybkie ===================================================

 if (typFFT==2)
     for e=1:log2(N)
         L=2^e;             %dlugosc blokow
         M=2^(e-1);         %liczba motylkow w bloku
         Wi = 1;            %startowa wartosc wsp bazy w etapie
         W=cos(2*pi/L)-1j*sin(2*pi/L);
                            %mnoznik bazy
         for m=1:M          %przejscie przez kolejne motylki
             for g=m:L:N    %przejscie przez kolejne bloki
                 d=g+M;     %indeks dolnej probki motylka (gorna+szerokosc)
                 T=x(d)*Wi;
                 x(d)=x(g)-T;
                 x(g)=x(g)+T;
             end
             Wi=Wi*W;
         end
     end
 end
 
 %% ============= porownanie z matlabem ===================================
 xc_matl=fft(xc);
 blad_real=max(abs(real(x-xc_matl))) 
 blad_imag=max(abs(imag(x-xc_matl)))
             



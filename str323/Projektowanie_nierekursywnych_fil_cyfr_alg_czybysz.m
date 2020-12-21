%==========================================================================
% Projektowanie nierekursywnych filtrow cyfrowych metoda probkowania w
% dziedzinie czestotliwosci metoda aproksymacji Czybyszewa 
%==========================================================================
close all;
clear all;
clc;

L=20;                       %liczba poszukiwanych wspolczynnikow (parzysta)
N=2*L-1;                    %dlugosc filtra
Nr=5;                       %szerokosc pasma przepustowego (mniejsza od L)
wp=1;                       %waga pasma przepustowego
ws=1;                       %waga pasma zaporowego
R=200;                      %ile razy zbior testowy ma byc wiekszy niz 
                            %zbior ekstremow
tol=1e-8;                   %tolerancja rozwiazania                            
ifigs=1;                    %0- nie wyswietla wykresow podczas iteracji 1-T

M=L+1;                      %liczba czestotliwosci ekstremow
K=1+R*(M-1);                %liczba wszystkich badanych czestotliowsci

fz=(0:K-1)/(K-1);           %zbior czestotliwosci przeszukiwanych (K elem.)
k11=1;
k12=1+Nr*R;                 %granice pasma przepustowego
k21=1+(Nr+1)*R;
k22=K;                      %granice pasma zaporowego

K1=1+Nr*R+R/2;              %nr probki charakterystyki dla czest. granicz.
fd=[fz(1:K1) fz(K1:K)];     %czestotliwosci charakterystyczne filtra
Hd=[ones(1,K1) zeros(1,K-K1)];
                            %wymagane wartosci wzmocnienia
Wg=[wp*ones(1,K1) ws*ones(1,K-K1)];
                            %wektor wag
imax=1:R:K;                 %indeksy startowych czestotliwosci ekstremow


feMAX=fz(1:R:K);            
sigmaMAX=1e15;              %parametry startowego zbioru czestotliwosci
sigma=0;

%============== inicjalizacja miejsc dla wykresow =========================
f=figure('Position',[100,600,400,400]);
movegui(f);
f=figure('Position',[600,600,400,400]);
movegui(f);
f=figure('Position',[100,100,400,400]);
movegui(f);
f=figure('Position',[600,100,400,400]);
movegui(f);

n=0:L-1;
%============== petla glowna ==============================================
pet=0;
 while (sigmaMAX-sigma)>tol %dopoki nie bedzie spelniona tolerancja tol
     
     sigmaMAX-sigma         %wyswietla w konsoli blad charakterystyki
     H=Hd(imax);
     H=H';                  %zmiana orientacji wektora H
     W=Wg(imax);            
     
     fe=feMAX;              %nowe czestot. ekstremow w danym kroku petli
     
     A=[];                  %inicializacja macierzy kosinusow
   
     for m=0:M-1            %obliczanie macierzy kosinusow
         A=[A; cos(pi*fe(m+1)*n) ((-1)^m)/W(m+1)];
     end
     
                    
     c = pinv(A)*H;         %rozwiazanie rownania
     
     %=========== odp impulsowa ==========
     h=c(1:L);
     sigma=c(M);
     sigma=abs(sigma);
     g=h'/2;
     g(1)=2*g(1);
     g=[ fliplr(g(2:L)) g];
     if (ifigs==1) 
        figure(1);
        stem(g);
        title('Cala odp impulsowa h');
        pause(0.15);        
     end
     
     %========== ch-ka czestot. =========
     for k=0:K-1
         H(k+1)=cos(pi*fz(k+1)*n)*h;
         Herr(k+1)=Wg(k+1)*(H(k+1)-Hd(k+1));
     end
     if (ifigs==1)
         figure(2);
         subplot(2,1,1)
         plot(fz,Hd,'r',fz,H,'b');
         grid;
         title('Aktualna H(f)');
         subplot(2,1,2);
         plot(fz,Herr);
         grid;
         title('Błąd H(f)');
         pause(0.15); 
     end
     
     %======== znalezienie ekstremow =====
     
     Hmax = [];
     imax = [];
     for p=1:2                    
         if (p==1)              %pasmo przepustowe
             k1=k11;
             k2=k12;
         end
         if (p==2)              %pasmo zaporowe
             k1=k21;
             k2=k22;
         end
         
         Hmax=[ Hmax Herr(k1)]; 
         imax=[ imax k1 ];      %zapisz pierwszy element / indeks   
         k=k1+1;                %zwieksza indeks      
         
         while(Herr(k-1)==Herr(k))
             k=k+1;             %jezeli rowne to zwieksza indeks
         end      
         if Herr(k)<Herr(k+1)                
             sgn=1;             %charakterystyka narasta        
         else                                     
             sgn=-1;            %charakterystyka opada    
         end                                 
         k=k+1;                         
     
         while ( k <= k2 )      %szukanie kolejnych ekstremow   
             if sgn==1
                 while (k<k2) && Herr(k-1)<Herr(k)  
                     k=k+1;
                 end
             end
             if (sgn==-1)                
                 while (k<k2) && Herr(k-1)>Herr(k)
                     k=k+1;
                 end
             end
             
             sgn=-sgn;             
             Hmax=[ Hmax Herr(k)];
             imax=[imax k];     %zapamietaj kolejne ekstremum  
             k=k+1;         
         end 
     end
     
     if (ifigs==1)
         figure(3);
         plot(fz(imax),Hmax,'or',fz,Herr,'b');
         grid; 
         title('Blad charakterystyki i jego ekstrema');
         pause(0.15);
     end
     
     %============ wybror najwiekszych ========
     if ( length(Hmax)>M )
         disp('Wiecej ekstremow niz M+1');
         IM=[];
         G=abs(Hmax);
         LenG=length(G);
         while LenG>0
             Gmx=max(G);
             imx=find(G==Gmx);  %funkcja matlabowa szukajaca danego indeksu
             LenGmx=length(imx);
             IM=[IM imax(imx)];
             G(imx)=0;
             LenG=LenG-LenGmx;
         end
         
         IM=IM(1:M);
         IM=sort(IM);
         imax=IM;
     end
     sigmaMAX=max(abs(Hmax));
     feMAX=fz(imax);  
     
     if (ifigs==1) 
         figure(4);
         plot(fz(imax),Herr(imax),'or',fz,Herr,'b');
         grid;
         title('Blad charakterystyki i M+1 najwiekszych ekstremow');
         pause(0.15);
     end
     pet=pet+1;  
     
 end   
 
 %=============== koncowe wykresy =========================================
 
fz=fz/2;

figure(5);
stem(g);
title('Wynikowa odpowiedz impulsowa filtra');

figure(6);
plot(fz(imax),Herr(imax),'or',fz,Herr,'b'); 
grid;  
title('blad H(f) + jego ekstrema'); 

figure(7);
plot(fz,Hd,'r',fz,H,'b'); 
grid; 
title('Wynikowe H(f)'); 

figure(8);
plot(fz,20*log10(H),'b');
grid;
title('Wynikowe H(f) w dB');

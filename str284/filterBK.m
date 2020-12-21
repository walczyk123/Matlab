%==========================================================================
% Filtracja z wykorzystaniem buforow kolowych
%==========================================================================

function  y = filterBK(b,a,x)   
Nx=length(x);                   %dlugosc sygnalu x 
M=length(b);                    %liczba wspolczynnikow b 
N=length(a);                  	%liczba wspolczynnikow a 
a=a(2:N);
N=N-1;                          %usuniecie pierwszego wsp a(1)   

bx=zeros(1,M);                  %zainicjowanie buforow (puste)
by=zeros(1,N);
y=[];

ix=1;
iy=1;                           %zainicjowanie wskaznikow do buforow

for n=1:Nx                      %petla przechodzaca przez wszystkie probki
    bx(ix)=x(n);                %probka przypisana do bufora
    sum=0;
    ib=1;
    ia=1;                       %inicjalizacja zmiennych
    
    for i=1:M-1                 %suma probek wejsciowych
        sum=sum+bx(ix)*b(ib);
        ix=ix-1;                %zmniejszenie wskaznika
        if ix==0
            ix=M;               %gdy wskaznik bedzie zerem przypisz M
        end
    end
    sum=sum+bx(ix)*b(ib);       %dodanie skladnika po wyjsciu z petli
    
    for i=1:N-1                 %suma probek wejsciowych
        sum=sum-by(iy)*b(ib);
        iy=iy-1;                %zmniejszenie wskaznika
        if iy==0
            iy=N;               %gdy wskaznik bedzie zerem przypisz N
        end
    end
    sum=sum-by(iy)*b(ib);       %dodanie skladnika po wyjsciu z petli
    
    y(n)=sum;                   %zapisanie danej wyjsciowej w wektorze
    by(iy)=sum;                 %zapisanie danej wyjsciowej w buf. wyjsc.
end
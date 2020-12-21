%==========================================================================
% Filtracja z wykorzystaniem buforow przesuwnych
%==========================================================================
function  y = filterBP(b,a,x)  
Nx=length(x);                   %dlugosc sygnalu x 
M=length(b);                    %liczba wspolczynnikow b 
N=length(a);                  	%liczba wspolczynnikow a 
a=a(2:N);
N=N-1;                          %usuniecie pierwszego wsp a(1)   

bx=zeros(1,M);                  %zainicjowanie buforow (puste)
by=zeros(1,N);
y=[];        

for n=1:Nx                      %przejscie przez wszystkie probki syg. wej
    bx=[x(n) bx(1:M-1)];        %nowa probka dodana do bufora wyjsciowego
                                %z jego przodu
    y(n)=sum(bx.*b)-sum(by.*a); %suma probek wejsciowych i wyjsciowych    
    by=[y(n) by(1:N-1)];        %nowa probka do bufora wyjsciowego dodaje
                                %sie je z przodu wektora
end
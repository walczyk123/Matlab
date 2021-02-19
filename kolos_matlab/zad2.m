clc; close all; clear all;
%petla sprawdzajaca czy podano nieujemna liczbe y1 i czy jest liczba
while 1
    y1 = input("podaj nieujemna liczbe rzeczywista y1: ")
    if y1 < 0 && isnumeric( y1 ) 
        disp("podano zla liczbe")
    else
        disp("podano dobra liczbe y1")
        break
    end
end
%petla sprawdzajaca czy podano liczbe x1 mniejsza od y1 i czy jest liczba
while 1
    x1 = input("podaj liczbe rzeczywista x1, mniejsza od y1: ")
    if x1 < y1 && isnumeric( x1 ) 
        disp("podano dobra liczbe x1")
        break
    else
        disp("podano liczbe x1 wieksza lub rowna y1")
    end
end
%wektor z krokiem (1/12)*(y1-x1)
krok=(y1-x1)/12;
a=x1:krok:y1;
%obliczenie wartosci funkcji
fprintf('  a\t      S(a)\n')
for i=1:length(a) %petla dla kazdego a
    if (a(i) < -4)
        S(i)=4*exp(a(i)+4);
    elseif (a(i) == (-4))
        S(i)=(a(i).^4+1).^(1/5);
    elseif (a(i) > -4)&&(a(i) < -1)
        S(i)=abs((a(i)-1)/(5*(a(i).^2)));
    elseif (a(i) >= -1)&&(a(i) < 4)
        S(i)=log((a(i)+2).^2);
    else
        S(i)=4;
    end
    fprintf('%6.2f   %8.4f \n',a(i),S(i))
end 


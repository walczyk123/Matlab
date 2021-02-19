clc;close all; clear all;
%wprowadzanie zmiennych
c = input("wprowadz dolny koniec przedzialu:  ");
d = input("wprowadz gorny koniec przedzialu:  ");
n = input("wprowadz liczbe punktow tabelaryzacji:  ");
disp("Dane")
disp(["c= "+num2str(c)])
disp(["d= "+num2str(d)])
disp(["n= "+num2str(n)])
disp("Obliczone")
disp(["krok dx = ",num2str((d-c)/n)])

x=c:((d-c)/n):d; %wektor wartości x

fprintf(' L.p.\t    x\t     y(x)\n')
for i=1:length(x) %petla dla kazdego x
    licz(i)=i;
    if (x(i) > -4) && (x(i) <= 0)
        y(i)=log10((x(i).^2+1).^4);
    else
        y(i)=(((x(i).^3)-4).^(1/3)./(4*x(i).^2));
    end
    fprintf('%4.0f   %8.4f %8.4f \n',i,x(i),y(i))
end 



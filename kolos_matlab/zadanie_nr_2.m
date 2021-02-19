clc; 
close all;
clear all;
while 1
    w1 = input("Wprowadz W1 (niedodatnie): ")
    if w1 > 0 && isnumeric( w1 ) 
        disp("blad: w1 dodatnie!")
    else
        disp("w1: 0K")
        break
    end
end
while 1
    w2 = input("Wprowadz w2 (wieksze niż w1): ")
    if w2<=w1 && isnumeric( w2 ) 
        disp("blad: w2 <= w1")
    else
        disp("w2: OK")
        break
    end
end
c=w1:(w2-w1)*(1/8):w2;
fprintf('    c  \t        P(c)  \n')
for k=1:length(c)
    if c(k) < -4
        P(k) = abs(c(k)-3)/(3*(c(k).^3));
    elseif c(k) == (-4)
        P(k) = (-4);
    elseif (c(k) > -4)&&(c(k) <= 1)
        P(k) = ((c(k).^5)+5)^(0.2);
    elseif (c(k) > 1)&&(c(k) < 5)
        P(k) = 2*exp(c(k)+1);
    else
        P(k) = log(c(k)+1);
    end
    fprintf('%10.4f   %10.4f \n',c(k),P(k))
end 


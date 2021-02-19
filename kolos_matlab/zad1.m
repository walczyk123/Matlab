clc; close all; clear all;
%dane
x=2.5;
y=-3.2;
z=5^(1/4);
a=1.9;
b=4.2;
d=5.1;
%obliczone
p=((x-3)^3)*(cos((x-3)^5)^3)+log((x+3)^3)
q=(abs(0.4*z-11)+((x^2)+2)^(1/4))/(0.5*(x^2)*(y+2))
r=((a+y)/((a-y)*(2*(x^2)))+2*cos((pi*y)^3))^(1/5)
s=exp((3+b)/(3*x*y))+exp(2*(a-b)+abs(x-2))
t=(x+y)*(z^(1/(5*d)))+(5/(5+(sin(1+d)^2)))
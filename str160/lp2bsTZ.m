%==========================================================================
% Przeksztalcenie Lp na Hp TZ (dolnoprzepustowy na analogowy filtr pasmowo-
% zaporowy) str. 144 wz 6.30-6.34
%==========================================================================
function [zz,pp,wzm] = lp2bsTZ(z,p,wzm,w0,dw)
    zz=[];
    pp=[];
    for i=1:length(z)
        zz=[zz roots([1 -dw/z(i) w0^2])'];
        wzm=wzm*(-z(i));
    end
    for i=1:length(p)
        pp=[pp roots([1 -dw/p(i) w0^2])'];
        wzm=wzm/(-p(i));
    end
    for i=1:(length(p)-length(z))
        zz=[zz roots([1 0 w0^2])'];
end
            
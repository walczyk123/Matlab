%==========================================================================
% Przeksztalcenie Lp na Hp TZ (dolnoprzepustowy na analogowy filtr pasmowo-
% przepustowy) str. 143 wz 6.22-6.29
%==========================================================================
function [zz,pp,wzm] = lp2bpTZ(z,p,wzm,w0,dw)
    zz=[];
    pp=[];
    for i=1:length(z)
        zz=[zz roots([1 -z(i)*dw w0^2])'];
        wzm=wzm/dw;
    end
    for i=1:length(p)
        pp=[pp roots([1 -p(i)*dw w0^2])'];
        wzm=wzm*dw;
    end
    for i=1:(length(p)-length(z))
        zz=[zz 0];
end
            
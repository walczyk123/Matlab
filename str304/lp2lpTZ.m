%==========================================================================
% Przeksztalcenie Lp na Lp TZ (dolnoprzepustowy na analogowy filtr dolno-
% przepustowy) str. 140 wz 6.16
%==========================================================================
function [zz,pp,wzm] = lp2lpTZ(z,p,wzm,w0)
    zz=[];
    pp=[];
    for i=1:length(z)
        zz=[zz z(i)*w0];
        wzm=wzm/w0;
    end
    for i=1:length(p)
        pp=[pp p(i)*w0];
        wzm=wzm*w0;
    end
end
            
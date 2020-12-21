%==========================================================================
% Przeksztalcenie Lp na Hp TZ (dolnoprzepustowy na analogowy filtr gorno-
% przepustowy) str. 140 wz 6.19
%==========================================================================
function [zz,pp,wzm] = lp2hpTZ(z,p,wzm,w0)
    zz=[];
    pp=[];
    for i=1:length(z)
        zz=[zz w0/z(i)];
        wzm=wzm/(-p(i));
    end
    for i=1:length(p)
        pp=[pp w0/p(i)];
        wzm=wzm/(-p(i));
    end
    for i=1:(length(p)-length(z))
        zz=[zz 0];
end
            
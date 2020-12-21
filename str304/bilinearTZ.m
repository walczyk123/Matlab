function [zz,pp,wzm] = bilinearTZ(z,p,wzm,fpr)
pp = [];
zz = [];
for  k=1:length(z)
    zz = [ zz (2*fpr+z(k))/(2*fpr-z(k)) ];
    wzm = wzm*(2*fpr-z(k));
end
for  k=1:length(p)
    pp = [ pp (2*fpr+p(k))/(2*fpr-p(k)) ];
    wzm = wzm/(2*fpr-p(k));
end
if (length(p)>length(z)) 
    zz = [ zz -1*ones(1,length(p)-length(z)) ];
end
if (length(p)<length(z)) 
    pp = [ pp -1*ones(1,length(z)-length(p)) ];
end
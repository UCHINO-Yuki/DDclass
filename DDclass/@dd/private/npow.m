function [b1,b2] = npow(a1,a2,n)
% NPOW  b1+b2 := (a1+a2).^n for integer n.
%
%   written ... 2024-02-23 ... UCHINO Yuki

b1 = ones(size(a1),'like',a1);
b2 = zeros(size(a1),'like',a1);

%% 0^0
j = n == 0;
k = a1 == 0;
i = j & k;
b1(i) = nan;
b2(i) = nan;

%% 0^n
k = k & ~i;
b1(k) = 0;
b2(k) = 0;
i = i | k;

%% a^0
j = j & ~i;
b1(j) = 1;
b2(j) = 0;
i = i | j;

%% a^1
j = n == 1 & ~i;
b1(j) = a1(j);
b2(j) = a2(j);
i = i | j;
if all(i,'all')
    return;
end

%% otherwise
i = ~i;
r1 = a1(i);
r2 = a2(i);
tmpb1 = b1(i);
tmpb2 = b2(i);
ni = n(i);
k = ni>0;
while any(k,'all')
    l = k & mod(ni,2)==1;
    [tmpb1(l),tmpb2(l)] = dd_prod(tmpb1(l),tmpb2(l),r1(l),r2(l));
    ni(k) = floor(ni(k).*0.5);
    k = ni>0;
    [r1(k),r2(k)] = dd_sqr(r1(k),r2(k));
end
b1(i) = tmpb1;
b2(i) = tmpb2;
end

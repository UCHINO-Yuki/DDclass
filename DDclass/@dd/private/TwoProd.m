function [c,d] = TwoProd(a,b)
% TWOPROD   Error-free transformation c+d := a.*b
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = a .* b;
[ah,al] = Split(a);
[bh,bl] = Split(b);
d = al.*bl - (((c - ah.*bh) - al.*bh) - ah.*bl);
end
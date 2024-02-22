function [c,d] = TwoSqr(a)
% TWOSQR  Transform a.*a into c+d.
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = a .* a;
[ah,al] = Split(a);
d = al.*al - (((c - ah.*ah) - al.*ah) - ah.*al);
end
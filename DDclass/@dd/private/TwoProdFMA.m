function [c,d] = TwoProdFMA(a,b)
% TWOPRODFMA    Error-free ransformation c+d := a.*b
%
%   written ... 2024-02-23 ... UCHINO Yuki
c = a .* b;
d = FMA(a,b,-c);
end
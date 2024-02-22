function [c1,c2] = dd_prod(a1,a2,b1,b2)
% DD_PROD  Compute c1+c2 := (a1+a2).*(b1+b2).
%
%   written ... 2024-02-23 ... UCHINO Yuki

if issparse(a1) || issparse(a2) || issparse(b1) || issparse(b2)
    [c1,c2] = TwoProd(a1,b1);
    c2 = c2 + a1.*b2 + a2.*b1;
    [c1,c2] = FastTwoSum(c1,c2);
else
    [c1,c2] = TwoProdFMA(a1,b1);
    c2 = FMA(a1,b2,c2);
    c2 = FMA(a2,b1,c2);
    [c1,c2] = FastTwoSum(c1,c2);
end
end
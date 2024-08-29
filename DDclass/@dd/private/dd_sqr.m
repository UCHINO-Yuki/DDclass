function [c1,c2] = dd_sqr(a1,a2)
% DD_SQR  Compute c1+c2 := (a1+a2).^2.
%
%   written ... 2024-02-23 ... UCHINO Yuki

if issparse(a1) || issparse(a2)
    [c1,c2] = TwoSqr(a1);
    c2 = c2 + 2.*a1.*a2;
    [c1,c2] = FastTwoSum(c1,c2);
else
    [c1,c2] = TwoProdFMA(a1,a1);
    c2 = c2 + 2.*a1.*a2;
    [c1,c2] = FastTwoSum(c1,c2);
end
end
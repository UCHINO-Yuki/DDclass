function c = hypot(a,b)
% HYPOT  Square root of sum of squares (hypotenuse).
%
%   See also HYPOT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

sft = -500 .* (abs(a.v1) > 3.2733906078961419e+150 | abs(b.v1) > 3.2733906078961419e+150) ...
    + 500 .* (((abs(a.v1) < 3.0549363634996047e-151) & (a.v1 ~= 0)) | ((abs(b.v1) < 3.0549363634996047e-151) & (b.v1 ~= 0)));
a1 = pow2(a.v1,sft);
a2 = pow2(a.v2,sft);
b1 = pow2(b.v1,sft);
b2 = pow2(b.v2,sft);
[a1,a2] = dd_sqr(a1,a2);
[b1,b2] = dd_sqr(b1,b2);
c = ldexp(sqrt(dd(a1,a2,"no")+dd(b1,b2,"no")),-sft);
end
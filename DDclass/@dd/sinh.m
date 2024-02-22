function a = sinh(a)
% SINH  Hyperbolic sine.
%
%   See also SINH
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% a = nan, return nan
% a = 0, return 0
finflag = isnan(a.v1) | a.v1 == 0;

sgn = sign(a.v1);
y = a;
y.v1 = y.v1 .* sgn;
y.v2 = y.v2 .* sgn;
i = y.v1 >= 7.10475860073943977113e+02;
if any(i,'all')
    a.v1(i) = sgn(i).*inf;
    a.v2(i) = sgn(i).*inf;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
i = y.v1 >= 0.5;
j = i & ~finflag;
if any(j,'all')
    e = exp(a(j));
    a(j) = ldexp(e-1./e,-1);
end
j = ~i & ~finflag;
if any(j,'all')
    f = expm1(y(j));
    f = ldexp(f + f./(f + 1), -1);
    a.v1(j) = sgn(j).*f.v1;
    a.v2(j) = sgn(j).*f.v2;
end
end
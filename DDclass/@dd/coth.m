function a = coth(a)
% COTH    Hyperbolic cotangent.
%
%   See also COTH
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% a = nan, return nan
finflag = isnan(a.v1);

% a = +-inf, return +-1
i = isinf(a.v1);
if any(i,'all')
    a.v1(i) = sign(a.v1(i));
    a.v2(i) = 0;
    finflag = finflag | i;
end

% a = 0, return inf
i = a.v1 == 0;
if any(i,'all')
    a.v1(i) = inf;
    a.v2(i) = inf;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
sgn = sign(a.v1);
y = a;
y.v1 = y.v1 .* sgn;
y.v2 = y.v2 .* sgn;
i = y.v1 >= 0.5;
j = i & ~finflag;
if any(j,'all')
    e = exp(a(j));
    inve = 1./e;
    a(j) = (e+inve)./(e-inve);
end
j = ~i & ~finflag;
if any(j,'all')
    f = expm1(y(j));
    g = 1./(f + 1);
    h = f + f.*g;
    f = (h+ldexp_(g,2))./h;
    a.v1(j) = f.v1 .* sgn(j);
    a.v2(j) = f.v2 .* sgn(j);
end
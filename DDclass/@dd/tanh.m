function a = tanh(a)
% TANH  hyperbolic tangent.
%
%   See also TANH
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% a = nan, return nan
% a = 0, return 0
finflag = isnan(a.v1) | a.v1 == 0;

% a = +-inf, return +-1
i = isinf(a.v1);
if any(i,'all')
    a.v1(i) = sign(a.v1(i));
    a.v2(i) = 0;
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
    a(j) = (e-inve)./(e+inve);
end
j = ~i & ~finflag;
if any(j,'all')
    f = expm1(y(j));
    g = 1./(f + 1);
    h = f + f.*g;
    f = h./(h+ldexp_(g,2));
    a.v1(j) = f.v1 .* sgn(j);
    a.v2(j) = f.v2 .* sgn(j);
end

end
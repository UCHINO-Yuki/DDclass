function a = cosh(a)
% COSH  Hyperbolic cosine.
%
%   See also COSH
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% a = nan, return nan
finflag = isnan(a.v1);

% a = 0, return 1
i = a.v1 == 0;
if any(i,'all')
    a.v1(i) = 1;
    a.v2(i) = 0;
    finflag = finflag | i;
end

i = abs(a.v1) >= 7.10475860073943977113e+02;
if any(i,'all')
    a.v1(i) = inf;
    a.v2(i) = inf;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
e = exp(a(~finflag));
a(~finflag) = ldexp(e+1./e,-1);

end
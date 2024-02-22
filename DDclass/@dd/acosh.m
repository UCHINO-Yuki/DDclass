function a = acosh(a)
% ACOSH  Inverse hyperbolic cosine.
%
%   See also ACOSH
%
%   acosh(a) = log(a + sqrt(a.^2 - 1))
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% a = nan, return nan (=a)
% a = +inf, return +inf (=a)
finflag = isnan(a.v1) | a.v1 == inf;

% a < 0, return nan
i = a.v1 < 1;
if any(i,'all')
    a.v1(i) = nan;
    a.v2(i) = nan;
    finflag = finflag | i;
end

% a = 1, return 0
i = a.v1 == 1 & a.v2 == 0;
if any(i,'all')
    a.v1(i) = 0;
    a.v2(i) = 0;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
a(~finflag) = a(~finflag)-1;

% for a > 2^-106
i = ~finflag & (a.v1>1.2325951644078300e-32);
if any(i,'all')
    b = a(i);
    a(i) = log1p(b + sqrt(b.*(b+2)));
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

% for super small a
i = ~finflag;
a(i) = sqrt(ldexp_(a(i),2));
end
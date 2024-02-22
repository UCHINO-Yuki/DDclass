function a = atanh(a)
% ATANH  Inverse hyperbolic tangent.
%
%   See also ATANH
%
%   atanh(a) = log1p(2*a./(1-a))/2
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% a = nan, return nan
% a = 0, return 0
finflag = isnan(a.v1) | a.v1 == 0;

% a < -1 or 1 < a, return nan
i = (a.v1 < -1) | (a.v1 > 1);
if any(i,'all')
    a.v1(i) = NaN;
    a.v2(i) = NaN;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
if any(finflag,'all')
    x = a(~finflag);
    a(~finflag) = ldexp_(log1p(ldexp_(x,2)./(1-x)),0.5);
else
    a = ldexp_(log1p(ldexp_(a,2)./(1-a)),0.5);
end

end
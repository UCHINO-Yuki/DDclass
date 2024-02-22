function a = asin(a)
% ASIN  Inverse sine in radians.
%
%   See also ASIN
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return;
end

% if a = nan, return nan (= a)
% if a < 2^-52, return a (= a)
finflag = isnan(a.v1) | abs(a.v1) < 2.2204460492503131e-16;

% if |a|>1, return nan
i = (a.v1 > 1) | (a.v1 < -1);
if any(i,'all')
    a.v1(i) = NaN;
    a.v2(i) = NaN;
    finflag = finflag | i;
end

j = a.v2 == 0;
i = a.v1 == -1 & j;
if any(i,'all')
    a(i) = -dd.ddpiby2;
    finflag = finflag | i;
end

i = a.v1 == 1 & j;
if any(i,'all')
    a(i) = dd.ddpiby2;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
if any(finflag,'all')
    y = a(~finflag);
    [y1,y2] = dd_sqr(y.v1,y.v2);
    a(~finflag) = atan2(y,sqrt(1-dd(y1,y2,"no")));
else
    y = a;
    [y1,y2] = dd_sqr(y.v1,y.v2);
    a = atan2(y,sqrt(1-dd(y1,y2,"no")));
end

end
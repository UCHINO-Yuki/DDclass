function a = acosd(a)
% ACOSD  Inverse cosine in degrees.
%
%   See also ACOSD
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return;
end

% if a = nan, return nan (= a)
finflag = isnan(a.v1);

i = (a.v1 > 1) | (a.v1 < -1);
if any(i,'all')
    a.v1(i) = NaN;
    a.v2(i) = NaN;
    finflag = finflag | i;
end

j = a.v2 == 0;
i = a.v1 == -1 & j;
if any(i,'all')
    a.v1(i) = 180;
    a.v2(i) = 0;
    finflag = finflag | i;
end

i = a.v1 == 0;
if any(i,'all')
    a.v1(i) = 90;
    a.v2(i) = 0;
    finflag = finflag | i;
end

i = a.v1 == 1 & j;
if any(i,'all')
    a.v1(i) = 0;
    a.v2(i) = 0;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
if any(finflag,'all')
    y = a(~finflag);
    [y1,y2] = dd_sqr(y.v1,y.v2);
    a(~finflag) = atan2d(sqrt(1-dd(y1,y2,"no")),y);
else
    y = a;
    [y1,y2] = dd_sqr(y.v1,y.v2);
    a = atan2d(sqrt(1-dd(y1,y2,"no")),y);
end

end
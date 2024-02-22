function a = atand(a)
% ATAND  Inverse tangent in degrees.
%
%   See also ATAND
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% a = nan, return nan
% a = 0, return 0
finflag = isnan(a.v1) | a.v1 == 0;

% a = 1, return pi/4
i = a.v1 == 1 & a.v2 == 0;
if any(i,'all')
    a.v1(i) = 45;
    a.v2(i) = 0;
    finflag = finflag | i;
end

% if a = inf or -inf, return sign(a).*pi/2
i = isinf(a.v1);
if any(i,'all')
    sgn = sign(a.v1(i));
    a.v1(i) = sgn.*90;
    a.v2(i) = 0;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
a(~finflag) = atan2d(a(~finflag),1);

end
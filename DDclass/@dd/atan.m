function a = atan(a,b)
% ATAN   Inverse tangent in radians
%
%   See also ATAN
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd = []
end

if nargin == 2
    a = a./b;
end

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
    a(i) = dd.ddpiby4;
    finflag = finflag | i;
end

% if a = inf or -inf, return sign(a).*pi/2
i = isinf(a.v1);
if any(i,'all')
    sgn = sign(a.v1(i));
    a.v1(i) = sgn.*dd.ddpiby2.v1;
    a.v2(i) = sgn.*dd.ddpiby2.v2;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
a(~finflag) = atan2(a(~finflag),1);

end
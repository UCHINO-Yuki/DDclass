function a = tand(a)
% TAND   Tangent of argument in degrees
%
%   See also TAND
%
%   tan(a*pi/180) = sin(a*pi/180)./cos(a*pi/180)
%   cos(a*pi/180) = cos(k*pi/1024).*cos(r) - sin(k*pi/1024).*sin(r)
%   sin(a*pi/180) = sin(k*pi/1024).*cos(r) + cos(k*pi/1024).*sin(r)
%   with a*pi/180 =: k*pi/1024 + r
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-17 ... UCHINO Yuki
%   revised ... 2024-03-21 ... UCHINO Yuki
%   revised ... 2024-03-24 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% if a = nan, return nan (= a)
finflag = isnan(a.v1);

% if a = inf or -inf, return nan
i = isinf(a.v1);
if any(i,'all')
    a.v1(i) = NaN;
    a.v2(i) = NaN;
    finflag = finflag | i;
end

% if a = 90*n with odd n, return +-inf
n = floor(a./90);
i = (a==n.*90) & ~finflag;
n =  n-ldexp_(floor(ldexp_(n,0.25)),4); % mod(n,4)
j = i & n==1;
if any(j,'all')
    a.v1(j) = inf;
    a.v2(j) = inf;
    finflag = finflag | j;
end
j = i & n==3;
if any(j,'all')
    a.v1(j) = -inf;
    a.v2(j) = -inf;
    finflag = finflag | j;
end

if all(finflag,'all')
    return;
end

%% other cases
anyflag = any(finflag,'all');
if anyflag
    r = a(~finflag);
else
    r = a;
end
rowflag = isrow(r);
if rowflag
    r = r.';
end

if any(r.v2)
    s1 = sind(dd(r.v1));
    s2 = sind(dd(r.v2));
    c1 = cosd(dd(r.v1));
    c2 = cosd(dd(r.v2));
    c1 = (s1 .* c2 + c1 .* s2)./(c1 .* c2 - s1 .* s2);
    if anyflag
        if rowflag
            a(~finflag) = c1.';
        else
            a(~finflag) = c1;
        end
    else
        if rowflag
            a = c1.';
        else
            a = c1;
        end
    end
    return;
end

% Argument reduction k*pi/1024 + r := a*pi/180
if any(abs(r.v1) >= 4.4565841414273690e+29, 'all')
    warning([mfilename ' for dd: Cannot guarantee the success of argument reduction.']);
end
r = ldexp(r,10);                        % r*1024
k = round(r./180);                      % round(r/180)
r = (r - 180.*k) .* dd.ddpiby184320;    % .* pi/1024/180
j1 = double(k-ldexp(floor(ldexp(k,-11)),11));   % j1 := mod(k,2048)
j2 = mod(j1,1024);                              % j2 := mod(k,1024)

% sink := sin(k.*pi/1024) using table
sgn = -1.*(j1>1024)+(j1<=1024);
idx = (j2>=512).*(1024-j2) + (j2<512).*j2 + 1;
sink = sgn.*dd.sin_tab(idx);

% cosk := cos(k.*pi/1024) using table
l = (512<=j1 & j1<1536);
sgn = -1.*l+(~l);
idx = (j2>=512).*(1024-j2) + (j2<512).*j2 + 1;
cosk = sgn.*dd.cos_tab(idx);

% sinr := sin(r)
r2 = r.*r;
sinr = r2.*dd.sinfact_tab.v1(4);
sinr = r2.*(sinr+dd.sinfact_tab.v1(3));
sinr = r2.*(sinr+dd.sinfact_tab(2));
sinr = r2.*(sinr+dd.sinfact_tab(1));
sinr = r + r.*sinr;

% cosr := cos(r)
cosr = r2.*dd.cosfact_tab.v1(3);
cosr = r2.*(cosr+dd.cosfact_tab.v1(2));
cosr = r2.*(cosr+dd.cosfact_tab(1));
cosr = 1 + ldexp(-r2,-1) + r2.*cosr;

% tan(a) := sin(a)./cos(a)
% sin(a) := sink.*cosr + cosk.*sinr
% cos(a) := cosk.*cosr - sink.*sinr
j1 = sink.*cosr + cosk.*sinr;
j2 = cosk.*cosr - sink.*sinr;
if anyflag
    if rowflag
        a(~finflag) = (j1./j2).';
    else
        a(~finflag) = j1./j2;
    end
else
    if rowflag
        a = (j1./j2).';
    else
        a = j1./j2;
    end
end
end
function a = cos(a)
% COS   Cosine of argument in radians..
%
%   See also COS
%
%   cos(a) = cos(k*pi/1024).*cos(r) - sin(k*pi/1024).*sin(r)
%   with a =: k*pi/1024 + r
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

% if a = 0, return 1
i = a.v1 == 0;
if any(i,'all')
    a.v1(i) = 1;
    a.v2(i) = 0;
    finflag = finflag | i;
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
    s1 = sin(dd(r.v1));
    s2 = sin(dd(r.v2));
    c1 = cos(dd(r.v1));
    c2 = cos(dd(r.v2));
    if anyflag
        if rowflag
            a(~finflag) = (c1 .* c2 - s1 .* s2).';
        else
            a(~finflag) = c1 .* c2 - s1 .* s2;
        end
    else
        if rowflag
            a = (c1 .* c2 - s1 .* s2).';
        else
            a = c1 .* c2 - s1 .* s2;
        end
    end
    return;
end

% Argument reduction k*pi/1024 + r := a
if any(abs(r.v1) > 2.4890261331223109e+29,'all')
    warning([mfilename ' for dd: Cannot guarantee the success of argument reduction.']);
end
k = round(r .* dd.dd1024bypi);
if issparse(k)
    for i=1:5
        [j1,j2] = TwoProd(k.v1,dd.piby1024_tab(i));    % k*pi/1024
        rr = r - dd(j1,j2,"no");
        [j1,j2] = TwoProd(k.v2,dd.piby1024_tab(i));
        rr = rr - dd(j1,j2,"no");
        if all(r.v1==rr.v1,'all') && all(r.v2==rr.v2,'all')
            break;
        end
        r = rr;
    end
else
    for i=1:5
        [j1,j2] = TwoProdFMA(k.v1,dd.piby1024_tab(i));    % k*pi/1024
        rr = r - dd(j1,j2,"no");
        [j1,j2] = TwoProdFMA(k.v2,dd.piby1024_tab(i));
        rr = rr - dd(j1,j2,"no");
        if all(r.v1==rr.v1,'all') && all(r.v2==rr.v2,'all')
            break;
        end
        r = rr;
    end
end
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

% cos(a) := cosk.*cosr - sink.*sinr
if anyflag
    if rowflag
        a(~finflag) = (cosk.*cosr - sink.*sinr).';
    else
        a(~finflag) = cosk.*cosr - sink.*sinr;
    end
else
    if rowflag
        a = (cosk.*cosr - sink.*sinr).';
    else
        a = cosk.*cosr - sink.*sinr;
    end
end
end

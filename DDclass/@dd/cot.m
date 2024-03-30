function a = cot(a)
% COT    Cotangent of argument in radians.
%
%   See also COT
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-17 ... UCHINO Yuki
%   revised ... 2024-03-30 ... UCHINO Yuki

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

% if a = 0, return inf
i = a.v1 == 0;
if any(i,'all')
    a.v1(i) = inf;
    a.v2(i) = inf;
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
    t1 = tan(dd(r.v1));
    t2 = tan(dd(r.v2));
    t1 = (1 - t1.*t2)./(t1 + t2);
    if anyflag
        if rowflag
            a(~finflag) = t1.';
        else
            a(~finflag) = t1;
        end
    else
        if rowflag
            a = t1.';
        else
            a = t1;
        end
    end
    return;
end

% Argument reduction k*pi/1024 + r := a
huge = abs(r.v1) > 2.4890261331223109e+29;
r(huge) = reduction(r.v1(huge),'tan');
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

% tan(a) := sin(a)./cos(a)
% sin(a) := sink.*cosr + cosk.*sinr
% cos(a) := cosk.*cosr - sink.*sinr
j1 = sink.*cosr + cosk.*sinr;
j2 = cosk.*cosr - sink.*sinr;
r = j2./j1;

if anyflag
    if rowflag
        a(~finflag) = r.';
    else
        a(~finflag) = r;
    end
else
    if rowflag
        a = r.';
    else
        a = r;
    end
end
end
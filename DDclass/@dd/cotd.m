function a = cotd(a)
% COTD    Cotangent of argument in degrees.
%
%   See also COTD
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-17 ... UCHINO Yuki

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
n =  n-ldexp_(floor(ldexp_(n,0.5)),2); % mod(n,2)
j = i & n==1;
if any(j,'all')
    a.v1(j) = 0;
    a.v2(j) = 0;
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

% Argument reduction k*pi/1024 + r := a
k = round(r.v1 .* 5.6888888888888891e+00);      % r*1024/180
r = (ldexp(r,10) - 180.*k) .* dd.ddpiby184320;  % .* pi/1024/180
j1 = k-pow2(floor(pow2(k,-11)),11);             % j1 = mod(k,2048)
j2 = k-pow2(floor(pow2(k,-10)),10);             % j2 = mod(k,1024)

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
        a(~finflag) = (j2./j1).';
    else
        a(~finflag) = j2./j1;
    end
else
    if rowflag
        a = (j2./j1).';
    else
        a = j2./j1;
    end
end
end

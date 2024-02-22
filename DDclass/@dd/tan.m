function a = tan(a)
% TAN   Tangent of argument in radians
%
%   See also TAN
%
%   tan(a) = sin(a)./cos(a)
%   cos(a) = cos(k*pi/1024).*cos(r) - sin(k*pi/1024).*sin(r)
%   sin(a) = sin(k*pi/1024).*cos(r) + cos(k*pi/1024).*sin(r)
%   with a =: k*pi/1024 + r
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% if a = nan, return nan (= a)
% if a = 0, return 0 (= a)
finflag = isnan(a.v1) | a.v1 == 0;

% if a = inf or -inf, return nan
i = isinf(a.v1);
if any(i,'all')
    a.v1(i) = NaN;
    a.v2(i) = NaN;
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
    rowflag = isrow(a);
    if rowflag
        r = a.';
    else
        r = a;
    end
end

% Argument reduction k*pi/1024 + r := a
invpi = 3.2594932345220167e+02;                     % 1024/pi
k = round(r.v1 .* invpi);
if issparse(k)
    [j1,j2] = TwoProd(k,3.0679615757712823e-03);    % k*pi/1024
    r = r - dd(j1,j2,"no");
    [j1,j2] = TwoProd(k,1.1959441397923371e-19);
    r = r - dd(j1,j2,"no");
    r = r + k.*2.9245798923030661e-36;
else
    [j1,j2] = TwoProdFMA(k,3.0679615757712823e-03);
    r = r - dd(j1,j2,"no");
    [j1,j2] = TwoProdFMA(k,1.1959441397923371e-19);
    r = r - dd(j1,j2,"no");
    r = r + k.*2.9245798923030661e-36;
end
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
    a(~finflag) = j1./j2;
else
    if rowflag
        a = (j1./j2).';
    else
        a = j1./j2;
    end
end
end
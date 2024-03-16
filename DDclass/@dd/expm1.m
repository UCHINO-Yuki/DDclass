function a = expm1(a)
% EXPM1   Exponential
%
%   See also EXPM1
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-17 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return;
end

% a = nan, return nan(=a)
% |a| < 2^-106, return a
finflag = isnan(a.v1) | (abs(a.v1) < 1.2325951644078309e-32);

% a > 7.0978271289338397e+02, return inf
i = a.v1 > 7.0978271289338397e+02 & ~finflag;
if any(i,'all')
    a.v1(i) = Inf;
    a.v2(i) = Inf;
    finflag = finflag | i;
end

% a < -7.4513321910194111e+02, return -1
i = a.v1 < -7.4513321910194111e+02;
if any(i,'all')
    a.v1(i) = -1;
    a.v2(i) = 0;
    finflag = finflag | i;
end

% a = 1, return e-1
i = (a.v1 == 1) & (a.v2 == 0);
if any(i,'all')
    a(i) = dd.ddexpm1;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
anyflag = any(finflag,'all');
if anyflag
    xtmp = a(~finflag);
else
    xtmp = a;
end
rowflag = isrow(xtmp);
if rowflag
    xtmp = xtmp.';
end

invL = 1.4773197218702985e+03;              % 1024/log(2)
N = round(xtmp.v1.*invL);
J = N-pow2(floor(pow2(N,-10)),10);          % mod(N,1024);
N1 = N-J;
M = pow2(N1,-10);                           % (N-J)/1024
R = xtmp-pow2(N,-10).*dd.ddlog2;
Q = R.*dd.expfact_tab.v1(6);
Q = R.*(Q+dd.expfact_tab.v1(5));
Q = R.*(Q+dd.expfact_tab.v1(4));
Q = R.*(Q+dd.expfact_tab.v1(3));
Q = R.*(Q+dd.expfact_tab(2));
Q = R.*(Q+dd.expfact_tab(1));
Q = R + (Q+0.5).*R.*R;
J = J+1;
tab = dd.exp_tab(J);
if issparse(a.v1)
    tab = sparse(tab);
end
e = ldexp((tab - pow2(-M)) + tab .* Q, M);

if rowflag
    e = e.';
end
if anyflag
    a(~finflag) = e;
else
    a = e;
end
end
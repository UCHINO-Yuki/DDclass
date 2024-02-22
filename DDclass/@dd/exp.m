function a = exp(a)
% EXP   Exponential
%
%   See also EXP
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return;
end

% x = nan, return nan
finflag = isnan(a.v1);

% x > 709, return inf
i = a.v1 > 7.0978271289338397e+02;
if any(i,'all')
    a.v1(i) = Inf;
    a.v2(i) = Inf;
    finflag = finflag | i;
end

% x = 1, return e
i = (a.v1 == 1) & (a.v2 == 0);
if any(i,'all')
    a(i) = dd.dde;
    finflag = finflag | i;
end

% |a| < 2^-54, return 1+a
i = (abs(a.v1) < 5.5511151231257827e-17);
if any(i,'all')
    [a.v1(i),a.v2(i)] = FastTwoSum(1,a.v1(i));
    finflag = finflag | i;
end

% x < -709, return 0
i = a.v1 < -7.4513321910194111e+02;
if any(i,'all')
    a.v1(i) = 0;
    a.v2(i) = 0;
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
    rowflag = isrow(a);
    if rowflag
        xtmp = a.';
    else
        xtmp = a;
    end
end

invL = 1.4773197218702985e+03;              % 1024/log(2)
N = round(xtmp.v1.*invL);
J = N-pow2(floor(pow2(N,-10)),10);          % mod(N,1024);
N1 = N-J;
M = pow2(N1,-10);                           % (N-J)/1024
R = xtmp-pow2(N,-10).*dd.ddlog2;
Q = R.*dd.expfact_tab.v1(6);
Q = R.*(Q+dd.expfact_tab(5));
Q = R.*(Q+dd.expfact_tab(4));
Q = R.*(Q+dd.expfact_tab(3));
Q = R.*(Q+dd.expfact_tab(2));
Q = R.*(Q+dd.expfact_tab(1));
Q = R + (Q+0.5).*R.*R;
J = J+1;
tab = dd.exp_tab(J);
if issparse(a.v1)
    tab = sparse(tab);
end
e = ldexp(tab + tab .* Q, M);

if anyflag
    a(~finflag) = e;
else
    if rowflag
        a = e.';
    else
        a = e;
    end
end
end
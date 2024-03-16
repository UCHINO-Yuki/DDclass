function a = log(a)
% LOG  Natural logarithm
%
%   See also LOG
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-17 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return;
end

% x = nan, return nan
finflag = isnan(a.v1);

% x < 0, return nan
i = a.v1 < 0;
if any(i,'all')
    a.v1(i) = NaN;
    a.v2(i) = NaN;
    finflag = finflag | i;
end

% x = 0, return -inf
i = a.v1 == 0;
if any(i,'all')
    a.v1(i) = -Inf;
    a.v2(i) = -Inf;
    finflag = finflag | i;
end

% x = 1 or x = +inf, return 0
i = (a.v1 == 1 & a.v2 == 0) | (a.v1 == inf);
if any(i,'all')
    a.v1(i) = 0;
    a.v2(i) = 0;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% exp(-1/16) < x < exp(1/16)
i = 9.3941306281347581e-01 < a.v1 & a.v1 < 1.0644944589178593e+00 & ~finflag;
if any(i,'all')
    a(i) = log1p(a(i)-1);
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

% 1 <= 2^-M . xtmp = Y1 + Y2 <= 2
[Y1,m] = log2(xtmp.v1);
Y1 = pow2(Y1,1);
m = m-1;
Y2 = pow2(xtmp.v2,-m);

% xtmp = 2^m * (F+f)
F = round(pow2(Y1,10));
F = pow2(F,-10);
j = pow2(F-1,10)+1;
f = dd(Y1-F,Y2,"fast");

% log2(2^m * (F+f)) = mlog2 + log(F) + log(1+f/F)
u = (f+f)./(dd(Y1,Y2,"no")+F);
v = u.*u;
Q = v.*dd.logfact_tab.v1(3);
Q = v.*(Q+dd.logfact_tab(2));
Q = v.*(Q+dd.logfact_tab(1));
Q = u+u.*Q; % ~ log(1+f/F)
mlog2 = m.*dd.ddlog2;
logF = dd.log_tab(j);
if issparse(a.v1)
    mlog2 = sparse(mlog2);
    logF = sparse(logF);
    Q = sparse(Q);
end
btmp = mlog2 + logF + Q;

if rowflag
    btmp = btmp.';
end
if anyflag
    a(~finflag) = btmp;
else
    a = btmp;
end

end
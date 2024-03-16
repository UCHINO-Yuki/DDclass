function a = log1p(a)
% LOG1P  Compute natural logarithm of 1+X accurately for small X
%
%   See also LOG1P
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-17 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return;
end

% x = 0, return 0
% x = inf, return inf
% x = nan, return nan
finflag = a.v1 == 0 | a.v1 == inf | isnan(a.v1);

% x < -1, return nan
i = a.v1 < -1;
if any(i,'all')
    a.v1(i) = NaN;
    a.v2(i) = NaN;
    finflag = finflag | i;
end

% x = -1, return -inf
i = a.v1 == -1 & a.v2 == 0;
if any(i,'all')
    a.v1(i) = -Inf;
    a.v2(i) = -Inf;
    finflag = finflag | i;
end

% |x| < 2^-53
i = abs(a.v1) < 1.1102230246251565e-16 & ~finflag;
if any(i,'all')
    a(i) = ldexp_(ldexp_(a(i),8)-4.9406564584124654e-324,0.125);   % (8x-Smin)/8
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% exp(-1/16)-1 < x < exp(1/16)-1
i = (-6.0586937186524213e-02 < a.v1) & (a.v1 < 6.4494458917859432e-02) & ~finflag;
if any(i,'all')
    btmp = a(i);
    if isrow(btmp)
        btmp = btmp.';
    end
    s = ldexp(btmp,1) ./ (btmp + 2.0);  % 2x/(x+2)
    t = s.*s;
    R = t.*dd.logfact_tab.v1(9);
    R = t.*(R+dd.logfact_tab.v1(8));
    R = t.*(R+dd.logfact_tab.v1(7));
    R = t.*(R+dd.logfact_tab.v1(6));
    R = t.*(R+dd.logfact_tab(5));
    R = t.*(R+dd.logfact_tab(4));
    R = t.*(R+dd.logfact_tab(3));
    R = t.*(R+dd.logfact_tab(2));
    R = t.*(R+dd.logfact_tab(1));
    a(i) = s + (s .* R);
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
anyflag = any(finflag,'all');
if anyflag
    xtmp = a(~finflag) + 1;
else
    xtmp = a + 1;
end
rowflag = isrow(xtmp);
if rowflag
    xtmp = xtmp.';
end

% 1 <= 2^-M . c = Y1 + Y2 <= 2
[Y1,m] = log2(xtmp.v1);
Y1 = pow2(Y1,1);
m = m-1;
Y2 = pow2(xtmp.v2,-m);

% c = 2^m * (F+f)
F = round(pow2(Y1,10));
F = pow2(F,-10);
j = pow2(F-1,10)+1;
f = dd(Y1-F,Y2,"fast");

% log2(2^m * (F+f)) = mlog2 + log(F) + log(1+f/F)
u = (f+f)./(dd(Y1,Y2,"no")+F);
v = u.*u;
Q = v.*dd.logfact_tab.v1(5);
Q = v.*(Q+dd.logfact_tab(4));
Q = v.*(Q+dd.logfact_tab(3));
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
xtmp = mlog2 + logF + Q;

if rowflag
    xtmp = xtmp.';
end
if anyflag
    a(~finflag) = xtmp;
else
    a = xtmp;
end
end
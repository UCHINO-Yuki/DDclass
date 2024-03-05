function a = power(a,p)
% POWER    Element-wise power.
%
%   See also POWER
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-05 ... UCHINO Yuki

arguments (Input)
    a dd
    p dd {mustBeReal}
end

if isempty(a)
    return;
end

[flag,a,P] = sizeCheck(a,p);
if flag
    error('Arrays have incompatible sizes for this function.');
end

%% the exception cases
% if a or p = nan, return nan
finflag = isnan(a.v1) | isnan(P);
if any(finflag,'all')
    a.v1(finflag) = NaN;
    a.v2(finflag) = NaN;
end

% if A.^1, return A
i = P.v2==0;
finflag = finflag | (P.v1==1 & i);

% if A.^0, return 1
i = P.v1==0 & i;
if any(i,'all')
    a.v1(i) = 1;
    a.v2(i) = 0;
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

%% A.^integar
i = (P.v1==round(P.v1)) & ~finflag;
if any(i,'all')
    j = i & P.v1<0;
    P(j) = -P(j);
    [a.v1(i),a.v2(i)] = npow(a.v1(i),a.v2(i),P.v1(i));
    a(j) = 1./a(j);
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

%% otherwise
a(~finflag) = exp(P(~finflag).*log(a(~finflag)));
end
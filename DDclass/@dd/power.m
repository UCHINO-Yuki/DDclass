function a = power(a,p)
% POWER    Element-wise power.
%
%   See also POWER
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    p double {mustBeReal}
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

% A.^0 & A.^1
i = P==0;
if any(i,'all')
    a.v1(i) = 1;
    a.v2(i) = 0;
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

% A.^negative
i = P<0;
if any(i,'all')
    a(i) = nthroot(a(i),-P(i));
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

%% A.^integar
i = (P==round(P)) & ~finflag;
if any(i,'all')
    [a.v1(i),a.v2(i)] = npow(a.v1(i),a.v1(i),P(i));
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

%% otherwise
a(~finflag) = exp(P(~finflag).*log(a(~finflag)));

end
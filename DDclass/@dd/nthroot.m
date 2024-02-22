function c = nthroot(a,p)
% NTHROOT    Real nth root of real numbers.
%
%   See also NTHROOT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    p double {mustBeReal}
end

[flag,c,P] = sizeCheck(a,p);
if flag
    error('Arrays have incompatible sizes for this function.');
end

%% the exception cases
if isempty(a)
    return;
end

% if a or p = nan, return nan
finflag = isnan(c.v1) | isnan(p);
if any(finflag,'all')
    c.v1(finflag) = NaN;
    c.v2(finflag) = NaN;
end

% a=1 or p=1, return a
i = (A1 == 1 & A2 == 0) | P == 1;
finflag = finflag | i;

% p=2
i = P==2;
if any(i,'all')
    c(i) = sqrt(c(i));
    finflag = finflag | i;
end

if all(finflag,'all')
    return
end

%% Compute c := a.^-p
tmpA = c(~finflag);
tmpP = P(~finflag);
try
    tmpC = nthroot(tmpA.v1,tmpP);
catch
    error('invalid input for nthroot.');
end
tmpC = dd(1./tmpC);                                 % C1 = double(A).^-p
tmpC = tmpC+(tmpC.*(1-tmpA.*(tmpC.^tmpP)))./tmpP;   % C2 = C1+C1.*(1-A.*C1.^p)/p
tmpC = tmpC+(tmpC.*(1-tmpA.*(tmpC.^tmpP)))./tmpP;   % C3 = C2+C2.*(1-A.*C2.^p)/p
tmpC = tmpC+(tmpC.*(1-tmpA.*(tmpC.^tmpP)))./tmpP;   % C4 = C3+C3.*(1-A.*C3.^p)/p

% Compute B <- 1./(A.^-p)
c(~finflag) = 1./tmpC;

end
function a = erf(a)
% ERF   Error function.
%
%   See also ERF
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return;
end

% if a=nan, return nan
% if a=0, return 0
finflag = isnan(a.v1) | a.v1==0;

sgn = sign(a.v1);
a.v1 = a.v1 .* sgn;
a.v2 = a.v2 .* sgn;

% if a>=8.424560546875, return 1
i = a.v1 >= 8.424560546875;
if any(i,'all')
    a.v1(i) = 1;
    a.v2(i) = 0;
    finflag = finflag | i;
end

if all(finflag,'all')
    a.v1 = a.v1 .* sgn;
    a.v2 = a.v2 .* sgn;
    return;
end

%% other cases
i = a.v1 < 1 & ~finflag;
if any(i,'all')
    b = a(i);
    b2 = b.*b;
    bt = b2 .* dd.erffact_tab(30);
    for j=29:-1:1
        bt = b2.* (bt + dd.erffact_tab(j));
    end
    a(i) = dd.dd2bysqrtpi.*(b + b.*bt)./exp(b2);
    finflag = finflag | i;
end

i = a.v1 < 3 & ~finflag;
if any(i,'all')
    c = a(i);
    c2 = c.*c;
    ct = c2 .* dd.erffact_tab(60);
    for j=59:-1:1
        ct = c2.* (ct + dd.erffact_tab(j));
    end
    a(i) = dd.dd2bysqrtpi.*(c + c.*ct)./exp(c2);
    finflag = finflag | i;
end

i = a.v1 < 3.1 & ~finflag;
if any(i,'all')
    d = a(i);
    sqrt2d = dd.ddsqrt2 .* d;
    dt = 66./sqrt2d;
    for j=65:-1:1
        dt = j./(dt + sqrt2d);
    end
    a(i) = 1-dd.ddsqrt2bypi.*exp(-d.*d)./(dt + sqrt2d);
    finflag = finflag | i;
end

i = a.v1 < 3.6 & ~finflag;
if any(i,'all')
    e = a(i);
    sqrt2e = dd.ddsqrt2 .* e;
    et = 60./sqrt2e;
    for j=59:-1:1
        et = j./(et + sqrt2e);
    end
    a(i) = 1-dd.ddsqrt2bypi.*exp(-e.*e)./(et + sqrt2e);
    finflag = finflag | i;
end

i = ~finflag;
if any(i,'all')
    f = a(i);
    sqrt2f = dd.ddsqrt2 .* f;
    ft = 39./sqrt2f;
    for j=38:-1:1
        ft = j./(ft + sqrt2f);
    end
    a(i) = 1-dd.ddsqrt2bypi.*exp(-f.*f)./(ft + sqrt2f);
end

a.v1 = sgn.*a.v1;
a.v2 = sgn.*a.v2;
end
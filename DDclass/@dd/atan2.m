function c = atan2(a,b)
% ATAN2  Four-quadrant inverse tangent.
%
%   See also ATAN2
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-21 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

[flag,c,d] = sizeCheck(a,b);
if flag
    error('Arrays have incompatible sizes for this function.');
end

%% the exception cases
if isempty(c)
    return
end

% if a = nan, return nan
finflag = isnan(c.v1) | isnan(d.v1);
if any(finflag,'all')
    c.v1(finflag) = NaN;
    c.v2(finflag) = NaN;
end

% if a=0, return sign(b).*pi
i = c.v1 == 0;
if any(i,'all')
    sgn1 = d.v1(i)<0;
    c.v1(i) = sgn1.*dd.ddpi.v1;
    c.v2(i) = sgn1.*dd.ddpi.v2;
    finflag = finflag | i;
end

% if b=0, return sign(a).*pi/2
% if a=+-inf & b is finite, return sign(a).*pi/2
j = isinf(c.v1);
k = isinf(d.v1);
i = (d.v1 == 0 | (j & ~k)) & ~finflag;
if any(i,'all')
    sgn2 = sign(c.v1(i));
    c.v1(i) = sgn2.*dd.ddpiby2.v1;
    c.v2(i) = sgn2.*dd.ddpiby2.v2;
    finflag = finflag | i;
end

% if a=+-inf & b=inf, return sign(a).*pi/4
% if a=+-inf & b=-inf, return sign(a).*3*pi/4
i = j & k & ~finflag;
if any(i,'all')
    sgn3 = sign(c.v1(i));
    f = d.v1(i)>0;
    c.v1(i) = f.*sgn3.*dd.ddpiby4.v1 + (~f).*sgn3.*dd.dd3piby4.v1;
    c.v2(i) = f.*sgn3.*dd.ddpiby4.v2 + (~f).*sgn3.*dd.dd3piby4.v1;
    finflag = finflag | i;
end

% if b=-inf & a is finite, return sign(a).*pi
% if b=inf & a is finite, return 0
i = (k & ~j) & ~finflag;
if any(i,'all')
    sgn4 = sign(c.v1(i));
    g = d.v1(i)<0;
    c.v1(i) = g.*sgn4.*dd.ddpi.v1;
    c.v2(i) = g.*sgn4.*dd.ddpi.v2;
    finflag = finflag | i;
end

if all(finflag,'all')
    return;
end

%% other cases
anyflag = any(finflag,'all');
if anyflag
    y = c(~finflag);
    x = d(~finflag);
else
    y = c;
    x = d;
end

% abs
sgnx = sign(x.v1);
uu = dd(sgnx .* x.v1, sgnx .* x.v2, "no");
sgny = sign(y.v1);
vv = dd(sgny .* y.v1, sgny .* y.v2, "no");

% swap
i = uu < vv;
tmp = uu(i);
uu(i) = vv(i);
vv(i) = tmp;

% for general z
z = vv./uu;
k = z.v1 >= 1.4648437500000002e-02;
index = ceil(pow2(z.v1(k),10));
q = dd.atan_tab(index-15);
d = pow2(index,-10);
m = nextpow2(d);
uum = ldexp(uu(k),-m);
vvm = ldexp(vv(k),-m);
r = (vvm-d.*uum)./(uum+d.*vvm);
if isrow(r)
    r = r.';
end
r2 = r.*r;
q2 = r2.*dd.atanfact_tab.v1(5);
q2 = r2.*(q2+dd.atanfact_tab.v1(4));
q2 = r2.*(q2+dd.atanfact_tab.v1(3));
q2 = r2.*(q2+dd.atanfact_tab(2));
q2 = r2.*(q2+dd.atanfact_tab(1));
q2 = r + q + r .* q2;
z(k) = q2;

% for small z
k = ~k & (z.v1 >= 1.1102230246251565e-16);
zk = z(k);
zk2 = zk.*zk;
q2 = zk2.*dd(3.2666666666666666e+00,5.9211894646675015e-17,"no");   % zk2*49/15
q2 = zk2.*36./(13+q2);
q2 = zk2.*25./(11+q2);
q2 = ldexp_(zk2,16)./(9+q2);
q2 = zk2.*9./(7+q2);
q2 = ldexp_(zk2,4)./(5+q2);
q2 = zk2./(3+q2);
z(k) = zk./(1+q2);

z(i) = dd.ddpiby2 - z(i);
z(sgnx<0) = dd.ddpi - z(sgnx<0);
z(sgny<0) = -z(sgny<0);
if anyflag
    c(~finflag) = z;
else
    c = z;
end
end
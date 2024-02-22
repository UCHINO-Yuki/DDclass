function a = asinh(a)
% ASINH  Inverse hyperbolic sine.
%
%   See also ASINH
%
%   asinh(a) = log(a + sqrt(a.^2 + 1))
%
%   written ... 2024-02-23 ... UCHINO Yuki

%% the exception cases
if isempty(a)
    return
end

% a = nan, return nan
% a = 0, return 0
% a = +-inf, return +-inf
finflag = isnan(a.v1) | a.v1 == 0 | isinf(a.v1);

if all(finflag,'all')
    return;
end

%% other cases
a(~finflag) = abs(a(~finflag));

% for small |a|
i = ~finflag & (a.v1<1.e-8);
if any(i,'all')
    ai = a(i);
    a(i) = ai + ai.*ai.*ai.*dd.asinhfact_tab(1);
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

i = ~finflag & (a.v1<1.e-5);
if any(i,'all')
    bi = a(i);
    bi2 = bi.*bi;
    b = bi2 .* dd.asinhfact_tab(2);
    b = bi2 .* (b + dd.asinhfact_tab(1));
    a(i) = bi + bi.*b;
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

i = ~finflag & (a.v1<1.e-4);
if any(i,'all')
    ci = a(i);
    ci2 = ci.*ci;
    c = ci2 .* dd.asinhfact_tab(3);
    c = ci2 .* (c + dd.asinhfact_tab(2));
    c = ci2 .* (c + dd.asinhfact_tab(1));
    a(i) = ci + ci.*c;
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

i = ~finflag & (a.v1<1.e-2);
if any(i,'all')
    di = a(i);
    di2 = di.*di;
    d = di2 .* dd.asinhfact_tab(6);
    d = di2 .* (d + dd.asinhfact_tab(5));
    d = di2 .* (d + dd.asinhfact_tab(4));
    d = di2 .* (d + dd.asinhfact_tab(3));
    d = di2 .* (d + dd.asinhfact_tab(2));
    d = di2 .* (d + dd.asinhfact_tab(1));
    a(i) = di + di.*d;
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

i = ~finflag & (a.v1<1.e-1);
if any(i,'all')
    ei = a(i);
    ei2 = ei.*ei;
    e = ei2 .* dd.asinhfact_tab(9);
    e = ei2 .* (e + dd.asinhfact_tab(8));
    e = ei2 .* (e + dd.asinhfact_tab(7));
    e = ei2 .* (e + dd.asinhfact_tab(6));
    e = ei2 .* (e + dd.asinhfact_tab(5));
    e = ei2 .* (e + dd.asinhfact_tab(4));
    e = ei2 .* (e + dd.asinhfact_tab(3));
    e = ei2 .* (e + dd.asinhfact_tab(2));
    e = ei2 .* (e + dd.asinhfact_tab(1));
    a(i) = ei + ei.*e;
    finflag = finflag | i;
end
if all(finflag,'all')
    return;
end

% for general |a|
i = ~finflag;
[c1,c2] = dd_sqr(a.v1(i),a.v2(i));
a(i) = log(a(i) + sqrt(dd(c1,c2,"no")+1));

end
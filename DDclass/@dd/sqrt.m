function a = sqrt(a)
% SQRT    Square root.
%
%   See also SQRT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
end

if isempty(a)
    return;
end

% if a<0, return nan
idx = a.v1 < 0;
a(idx) = nan;

% if a=nan, return nan
idx = idx | isnan(a.v1);

if all(idx,'all')
    return;
end

% otherwise
b = a(~idx);
x = 1 ./ sqrt(b.v1);
ax = b.v1 .* x;
if issparse(ax)
    [d1,d2] = TwoSqr(ax);
else
    [d1,d2] = TwoProdFMA(ax,ax);
end
[c1,c2] = TwoSum(b.v1,-d1);
c2 = (c2 + b.v2) - d2;
c1 = c1 + c2;
a(~idx) = dd(ax,c1.*(x.*0.5),"default");
end

function c = plus(a,b)
% PLUS  Add numbers.
%
%   See also PLUS
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

try
    c1 = a.v1 + b.v1;
catch
    error('Arrays have incompatible sizes for this operation.');
end

if isempty(a.v1) || isempty(b.v1)
    c = dd(c1);
    return;
end

idx = ~isfinite(c1);
ctmp = c1(idx);

% [c1,c2] = TwoSum(a.v1,b.v1);
z = c1-a.v1;
c2 = (a.v1-(c1-z))+(b.v1-z);

if any(a.v2,'all')
    if any(b.v2,'all')
        % dd(a1,a2) + dd(b1,b2)
        c2 = c2+a.v2+b.v2;
    else
        % dd(a1,a2) + b1
        c2 = c2+a.v2;
    end
else
    if any(b.v2,'all')
        % a1 + dd(b1,b2)
        c2 = c2+b.v2;
    else
        % a1 + b1
        c1(idx) = ctmp;
        c2(idx) = ctmp;
        c = dd(c1,c2,"no");
        return
    end
end
c = dd(c1,c2,"fast");
c.v1(idx) = ctmp;
c.v2(idx) = ctmp;

end

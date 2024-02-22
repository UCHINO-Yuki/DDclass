function c = times(a,b)
% TIMES  Multiplication.
%
%   See also TIMES
%
%   written ... 2024-02-23 ... UCHINO Yuki

if islogical(a)
    try
        c1 = a .* b.v1;
    catch
        error('Arrays have incompatible sizes for this operation.');
    end
    c = dd(c1, a.*b.v2, "no");
    return;
end

if islogical(b)
    try
        c1 = a.v1 .* b;
    catch
        error('Arrays have incompatible sizes for this operation.');
    end
    c = dd(c1, a.v2.*b, "no");
    return;
end

if ~isUnderlyingType(a,'dd')
    a = dd(a);
end
if ~isUnderlyingType(b,'dd')
    b = dd(b);
end

try
    c1 = a.v1 .* b.v1;
catch
    error('Arrays have incompatible sizes for this operation.');
end

if isempty(a.v1) || isempty(b.v1)
    c = dd(c1);
    return;
end

idx = ~isfinite(c1);
ctmp = c1(idx);

if issparse(a.v1) || issparse(b.v1)
    % fma is not available for sparse array
    % [c1,c2] = TwoProd(a.v1,b.v1);
    [ah,al] = Split(a.v1);
    [bh,bl] = Split(b.v1);
    c2 = al.*bl - (((c1 - ah.*bh) - al.*bh) - ah.*bl);

    if any(a.v2,'all')
        if any(b.v2,'all')
            % dd(a1,a2) .* dd(b1,b2)
            c2 = c2 + a.v1 .* b.v2 + a.v2 .* b.v1;
        else
            % dd(a1,a2) .* b1
            c2 = c2 + a.v2 .* b.v1;
        end
    else
        if any(b.v2,'all')
            % a1 .* dd(b1,b2)
            c2 = c2 + a.v1 .* b.v2;
        else
            % a1 .* b1
            c1(idx) = ctmp;
            c2(idx) = ctmp;
            c = dd(c1,c2,"no");
            return
        end
    end

else
    % fma is available
    % [c1,c2] = TwoProdFMA(a.v1,b.v1);
    c2 = FMA(a.v1,b.v1,-c1);

    if any(a.v2,'all')
        if any(b.v2,'all')
            % dd(a1,a2) .* dd(b1,b2)
            c2 = FMA(a.v1,b.v2,c2);
            c2 = FMA(a.v2,b.v1,c2);
        else
            % dd(a1,a2) .* b1
            c2 = FMA(a.v2,b.v1,c2);
        end
    else
        if any(b.v2,'all')
            % a1 .* dd(b1,b2)
            c2 = FMA(a.v1,b.v2,c2);
        else
            % a1 .* b1
            c1(idx) = ctmp;
            c2(idx) = ctmp;
            c = dd(c1,c2,"no");
            return
        end
    end
end
c = dd(c1,c2,"fast");
c.v1(idx) = ctmp;
c.v2(idx) = ctmp;

end


function c = ldivide(a,b)
% LDIVIDE  Left array division.
%
%   See also LDIVIDE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

try
    c1 = b.v1 ./ a.v1;
catch
    error('Arrays have incompatible sizes for this operation.');
end

if isempty(a.v1) || isempty(b.v1)
    c = dd(c1);
    return
end

idx = ~isfinite(c1);
ctmp = c1(idx);

if issparse(a.v1) || issparse(b.v1)
    % fma is not available for sparse array
    [p,e] = TwoProd(c1, a.v1);
    c2 = (b.v1 - p) - e;

    if any(b.v2,'all')
        if any(a.v2,'all')
            % dd(b1,b2) ./ dd(a1,a2)
            c2 = ((c2 + b.v2) - c1.*a.v2) ./ a.v1;
        else
            % dd(b1,b2) ./ a1
            c2 = (c2 + b.v2) ./ a.v1;
        end
    else
        if any(a.v2,'all')
            % b1 ./ dd(a1,a2)
            c2 = (c2 - c1.*a.v2) ./ a.v1;
        else
            % b1 ./ a1
            c2 = c2 ./ a.v1;
        end
    end

else
    % fma is available
    [p,e] = TwoProdFMA(c1, a.v1);
    c2 = (b.v1 - p) - e;

    if any(b.v2,'all')
        if any(a.v2,'all')
            % dd(b1,b2) ./ dd(a1,a2)
            c2 = FMA(c1,-a.v2,c2 + b.v2) ./ a.v1;
        else
            % dd(b1,b2) ./ a1
            c2 = (c2 + b.v2) ./ a.v1;
        end
    else
        if any(a.v2,'all')
            % b1 ./ dd(a1,a2)
            c2 = FMA(c1,-a.v2,c2) ./ a.v1;
        else
            % b1 ./ a1
            c2 = c2 ./ a.v1;
        end
    end
end
c = dd(c1,c2,"fast");
c.v1(idx) = ctmp;
c.v2(idx) = ctmp;

end
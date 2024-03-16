function c = rdivide(a,b)
% RDIVIDE   Right array division.
%
%   See also RDIVIDE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

try
    c1 = a.v1 ./ b.v1;
catch
    error('Arrays have incompatible sizes for this operation.');
end

if isempty(a.v1) || isempty(b.v1)
    c = dd(c1);
    return
end

idx = ~isfinite(c1);
ctmp = c1(idx);

if issparse(a) || issparse(b)
    % fma is not available for sparse array
    [p,e] = TwoProd(c1, b.v1);
    c2 = (a.v1 - p) - e;

    if any(a.v2,'all')
        if any(b.v2,'all')
            % dd(a1,a2) ./ dd(b1,b2)
            c2 = ((c2 + a.v2) - c1.*b.v2) ./ b.v1;
        else
            % dd(a1,a2) ./ b1
            c2 = (c2 + a.v2) ./ b.v1;
        end
    else
        if any(b.v2,'all')
            % a1 ./ dd(b1,b2)
            c2 = (c2 - c1.*b.v2) ./ b.v1;
        else
            % a1 ./ b1
            c2 = c2 ./ b.v1;
        end
    end

else
    % fma is available
    [p,e] = TwoProdFMA(c1, b.v1);
    c2 = (a.v1 - p) - e;

    if any(a.v2,'all')
        if any(b.v2,'all')
            % dd(a1,a2) ./ dd(b1,b2)
            c2 = FMA(c1,-b.v2,c2+a.v2) ./ b.v1;
        else
            % dd(a1,a2) ./ b1
            c2 = (c2 + a.v2) ./ b.v1;
        end
    else
        if any(b.v2,'all')
            % a1 ./ dd(b1,b2)
            c2 = FMA(c1,-b.v2,c2) ./ b.v1;
        else
            % a1 ./ b1
            c2 = c2 ./ b.v1;
        end
    end
end
c = dd(c1,c2,"fast");
c.v1(idx) = ctmp;
c.v2(idx) = ctmp;

end

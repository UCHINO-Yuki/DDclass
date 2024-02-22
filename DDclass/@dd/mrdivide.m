function c = mrdivide(b,a)
% MRDIVIDE  Solve systems of linear equations xA = B for x.
%
%   See also MRDIVIDE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments
    b (:,:) dd
    a (:,:) dd
end

if isscalar(a) || isscalar(b)
    c = b./a;
    return;
end

szA = size(a.v1);
szB = size(b.v1);

if szA(2) ~= szB(2)
    error('Arrays have incompatible sizes for this operation.');
end

if isempty(a.v1) || isempty(b.v1)
    c = dd(b.v1/a.v1);
    return
end

c = (a'\b')';   % b/a = (a'\b')'
end
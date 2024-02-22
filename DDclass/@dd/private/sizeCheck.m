function [flag,a,b] = sizeCheck(a,b)
% SIZECHECK     Verify size compatibility
%
%   if arrays have incompatible sizes, return error
%
%   written ... 2024-02-23 ... UCHINO Yuki

if isempty(a) || isempty(b)
    flag = ~isequal(size(a),size(b));
    return
end

ndim = max(ndims(a),ndims(b));
sza = size(a,1:ndim);
szb = size(b,1:ndim);
szmax = max(sza,szb);

sza2 = szmax./sza;
flag = any(szmax ~= sza2 & szmax ~= sza);
if flag
    return
end
if nargout > 1
    a = repmat(a,sza2);
end

szb2 = szmax./szb;
flag = any(szmax ~= szb2 & szmax ~= szb);
if flag
    return
end
if nargout > 2
    b = repmat(b,szb2);
end

end
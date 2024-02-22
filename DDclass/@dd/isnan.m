function c = isnan(a)
% ISNAN   Determine which array elements are nan.
%
%   See also ISNAN
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = isnan(a.v1) | isnan(a.v2);
end
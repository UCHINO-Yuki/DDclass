function c = transpose(a)
% TRANSPOSE  Transpose vector or matrix
%
%   See also TRANSPOSE
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = dd(a.v1.',a.v2.',"no");
end
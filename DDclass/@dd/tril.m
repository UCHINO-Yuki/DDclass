function a = tril(a,k)
% TRIL  Lower triangular part of matrix.
%
%   See also TRIL
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    k (1,1) double {mustBeInteger} = 0
end

a.v1 = tril(a.v1,k);
a.v2 = tril(a.v2,k);

end
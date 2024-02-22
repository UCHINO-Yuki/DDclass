function c = diag(a,k)
% DIAG  Create diagonal matrix or get diagonal elements of matrix.
%
%   See also DIAG
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    k (1,1) double {mustBeInteger} = 0
end

c = dd(diag(a.v1,k),diag(a.v2,k),"no");
end


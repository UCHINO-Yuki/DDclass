function a = triu(a,k)
% TRIU  Upper triangular part of matrix.
%
%   See also TRIU
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    k (1,1) double {mustBeInteger} = 0
end

a.v1 = triu(a.v1,k);
a.v2 = triu(a.v2,k);

end
function a = ldexp(a,p)
% LDEXP  Compute c := a .* 2.^p
%
%   written ... 2024-02-23 ... UCHINO Yuki

a.v1 = pow2(a.v1,p);
a.v2 = pow2(a.v2,p);
end
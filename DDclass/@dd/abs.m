function a = abs(a)
% ABS   Absolute value for dd.
%
%   See also SIGN, HYPOT, NORM, VECNORM.
%
%   written ... 2024-02-23 ... UCHINO Yuki

idx = a.v1<0;
a.v1(idx) = -a.v1(idx);
a.v2(idx) = -a.v2(idx);
end


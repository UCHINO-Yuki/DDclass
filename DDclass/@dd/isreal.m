function c = isreal(a)
% ISREAL   Determine if input is real.
%
%   See also ISREAL
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = isreal(a.v1) && isreal(a.v2);
end
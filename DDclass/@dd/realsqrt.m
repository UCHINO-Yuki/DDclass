function a = realsqrt(a)
% REALSQRT    Square root for nonnegative real arrays.
%
%   See also REALSQRT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd {mustBeNonnegative}
end

a = sqrt(a);
end

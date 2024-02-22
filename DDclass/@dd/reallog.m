function a = reallog(a)
% REALLOG  Natural logarithm for nonnegative real arrays
%
%   See also REALLOG
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd {mustBeNonnegative}
end

a = log(a);
end
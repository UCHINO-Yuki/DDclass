function [a,e] = log2(a)
% LOG2  Base 2 logarithm and floating-point number dissection
%
%   See also LOG2
%
%   written ... 2024-02-23 ... UCHINO Yuki

if isempty(a)
    e = a;
    return;
end

if nargout == 2
    [a.v1,e] = log2(a.v1);
    a.v2 = pow2(a.v2,-e);
    return;
end

a = log(a)./dd.ddlog2;
end
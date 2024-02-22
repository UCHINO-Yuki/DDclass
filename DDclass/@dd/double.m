function [c1,c2] = double(a)
% DOUBLE  Double-precision arrays.
%
%   c1 = double(a)      returns c1 := a.v1
%   [c1,c2] = double(a) returns c1 := a.v1 & c2 := a.v2
%   
%   See also DOUBLE
%
%   written ... 2024-02-23 ... UCHINO Yuki

c1 = a.v1;
if nargout == 2
    c2 = a.v2;
end
end
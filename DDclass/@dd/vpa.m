function c = vpa(a,d)
% VPA  Variable-precision arithmetic (arbitrary-precision arithmetic).
%
%   See also VPA
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    d (1,1) {mustBeNumeric(d),mustBeInteger(d),mustBeInRange(d,2,536870912)} = digits
end

if nargin == 1
    c = vpa(a.v1) + vpa(a.v2);
else
    c = vpa(a.v1,d) + vpa(a.v2,d);
end
end
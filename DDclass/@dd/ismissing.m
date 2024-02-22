function c = ismissing(a,b)
% ISMISSING   Determine which array elements are missing.
%
%   See also ISMISSING
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd = []
end

if nargin == 2
    c = ismissing(a.v1,b.v1) & ismissing(a.v2,b.v2);
else
    c = ismissing(a.v1) | ismissing(a.v2);
end

end
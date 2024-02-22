function c = reshape(a,sz)
% RESHAPE  Reshape array.
%
%   See also REPMAT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
end
arguments (Input,Repeating)
    sz double {mustBeInteger}
end

try
    c1 = reshape(a.v1,sz{:});
catch
    error('Invalid input');
end
c = dd(c1,reshape(a.v2,sz{:}),"no");
end

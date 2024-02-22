function c = repelem(a,r)
% REPELEM   Repeat copies of array elements..
%
%   See also REPELEM
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
end
arguments (Input,Repeating)
    r double {mustBeInteger}
end
if numel(r) == 0
    error('invalid input for dd');
end

c = dd(repelem(a.v1,r{:}),repelem(a.v2,r{:}),"no");
end

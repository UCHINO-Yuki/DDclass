function c = repmat(a,r)
% REPMAT  Replicate and tile an array.
%
%   See also REPMAT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
end
arguments (Input,Repeating)
    r double {mustBeInteger}
end
if numel(r) == 0
    error('Invalid input');
end

c = dd(repmat(a.v1,r{:}),repmat(a.v2,r{:}),"no");
end

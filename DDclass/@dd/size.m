function varargout = size(a,dim)
% SIZE  Array size
%
%   See also SIZE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
end
arguments (Input,Repeating)
    dim double {mustBeInteger}
end

[varargout{1:nargout}] = size(a.v1,dim{:});

end

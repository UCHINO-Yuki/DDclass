function out = empty(varargin)
% EMPTY  Create empty array of dd.
%
%   See also EMPTY
%
%   written ... 2024-02-23 ... UCHINO Yuki

try
    b = double.empty(varargin{:});
catch
    error('Invalid input.');
end
out = dd(b,b,"no");
end
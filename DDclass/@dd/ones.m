function out = ones(varargin)
% ONES  Create array of all ones.
%
%   See also ONES
%
%   written ... 2024-02-23 ... UCHINO Yuki

for i=1:nargin-1
    if strcmp(varargin{i},'like') && isUnderlyingType(varargin{i+1},'dd')
        varargin{i+1} = varargin{i+1}.v1(1);
    end
end
try
    b = ones(varargin{:});
catch
    error('Invalid input.');
end
if ~isreal(b) || ~isUnderlyingType(b,'double')
    error('invalid input');
end
out = dd(b,zeros(varargin{:}),"no");
end
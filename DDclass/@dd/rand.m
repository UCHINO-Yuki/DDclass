function out = rand(varargin)
% RAND  Uniformly distributed random numbers.
%
%   See also RAND
%
%   written ... 2024-02-23 ... UCHINO Yuki

for i=1:nargin-1
    if strcmp(varargin{i},'like') && isUnderlyingType(varargin{i+1},'DD')
        varargin{i+1} = varargin{i+1}.v1(1);
    end
end
try
    b = rand(varargin{:});
catch
    error('Invalid input.');
end
if ~isreal(b) || ~isUnderlyingType(b,'double')
    error('Invalid input');
end
out = dd(b,pow2(b,-53),"fast");
out = ldexp(out.*1099511627775 + .5,-40);
end
function varargout = gather(a)
% GATHER   Transfer gpuArray object to local workspace.
%
%   See also GATHER
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input, Repeating)
    a dd
end

n1 = nargin;
n2 = nargout;
if n1 == n2 || n2 == 0
    varargout{n1} = dd(gather(a{n1}.v1),gather(a{n1}.v2),"no");
    for i=1:n1-1
        varargout{i} = dd(gather(a{i}.v1),gather(a{i}.v2),"no");
    end
else
    error('Invalid input or output');
end
end
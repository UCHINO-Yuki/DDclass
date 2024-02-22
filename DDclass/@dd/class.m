function c = class(a)
% CLASS  Class of object
%
%   See also CLASS
%
%   written ... 2024-02-23 ... UCHINO Yuki

if isgpuarray(a.v1)
    c = 'gpuArray';
else
    c = 'dd';
end
end
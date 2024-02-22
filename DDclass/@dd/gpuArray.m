function c = gpuArray(a)
% GPUARRAY   Array stored on GPU.
%
%   See also GPUARRAY
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = dd(gpuArray(a.v1),gpuArray(a.v2),"no");
end
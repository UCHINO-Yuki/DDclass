function c = isa(a,typename)
% ISA  Determine if input has specified data type.
%
%   See also ISA
%
%   written ... 2024-02-23 ... UCHINO Yuki

if isgpuarray(a.v1)
    c = isa(a.v1,typename);
else
    c = strcmp('DD',typename);
end
end
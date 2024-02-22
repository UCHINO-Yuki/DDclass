function c = ctranspose(a)
% CTRANSPOSE    Complex conjugate transpose
%
%   See also CTRANSPOSE
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = dd(a.v1',a.v2',"no");
end
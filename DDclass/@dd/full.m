function c = full(a)
% FULL  Convert sparse matrix to full storage.
%
%   See also FULL
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = dd(full(a.v1),full(a.v2),"no");
end


function c=blkdiag(a)
% BLKDIAG  Block diagonal matrix.
%
%   See also BLKDIAG
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input,Repeating)
    a dd
end

n = numel(a);
b1{n} = a{n}.v1;
b2{n} = a{n}.v2;
for i=1:n-1
    b1{i} = a{i}.v1;
    b2{i} = a{i}.v2;
end
c1 = blkdiag(b1{:});
c2 = blkdiag(b2{:});
c = dd(c1,c2,"no");
end


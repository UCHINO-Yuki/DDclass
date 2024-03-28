function c = ceil(a)
% CEIL  Round toward positive infinity
%
%   See also CEIL
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-28 ... UCHINO Yuki

b1 = ceil(a.v1);
b2 = zeros(size(b1),'like',b1);
i = b1 == a.v1;
b2(i) = ceil(a.v2(i));
[b1(i),b2(i)] = FastTwoSum(b1(i),b2(i));
c = DD(b1,b2,"no");
end
function c = floor(a)
% FLOOR  Round toward negative infinity
%
%   See also FLOOR
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-28 ... UCHINO Yuki

b1 = floor(a.v1);
b2 = zeros(size(b1),'like',b1);
i = b1 == a.v1;
b2(i) = floor(a.v2(i));
[b1(i),b2(i)] = FastTwoSum(b1(i),b2(i));
c = dd(b1,b2,"no");
end
function c = fix(a)
% FIX  Round towards zero
%
%   See also FIX
%
%   written ... 2024-03-28 ... UCHINO Yuki

b1 = fix(a.v1);
b2 = zeros(size(b1),'like',b1);
i = b1 == a.v1;
b2(i) = fix(a.v2(i));
[b1(i),b2(i)] = FastTwoSum(b1(i),b2(i));
c = DD(b1,b2,"no");
end
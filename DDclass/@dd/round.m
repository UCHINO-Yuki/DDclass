function c = round(a,varargin)
% ROUND  Round to nearest integer
%
%   See also ROUND
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-28 ... UCHINO Yuki

if nargin ~= 1
    error('Only one input argument is supported.');
end

b1 = round(a.v1);
b2 = zeros(size(b1),'like',b1);

i = b1 == a.v1;
b2(i) = round(a.v2(i),TieBreaker="tozero");
% b2(i) = round(a.v2(i));
% j = (abs(b2(i)-a.v2(i))==0.5);
% b2(j) = b2(j) - sign(b2(j));
[b1(i),b2(i)] = FastTwoSum(b1(i),b2(i));
i = ~i & (abs(b1-a.v1)==0.5) & (a.v2~=0);
b1(i) = b1(i) - sign(b1(i));
c = dd(b1,b2,"no");
end
function [c,d] = TwoSum(a,b)
% TWOSUM  Transform a+b into c+d.
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = a+b;
z = c-a;
d = (a-(c-z))+(b-z);
end
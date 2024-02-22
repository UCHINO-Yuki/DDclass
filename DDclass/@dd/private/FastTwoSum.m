function [c,d] = FastTwoSum(a,b)
% FASTTWOSUM  Transform a+b into c+d.
%
%   written ... 2024-02-23 ... UCHINO Yuki

c = a+b;
d = (a-c) + b;
end
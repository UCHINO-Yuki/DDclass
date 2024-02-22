function c = lt(a,b)
% LT Determine less than
%
%   See also LT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

c = ~(a >= b);
end
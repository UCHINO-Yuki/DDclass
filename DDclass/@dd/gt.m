function c = gt(a,b)
% GT    Determine greater than.
%
%   See also GT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

c = ~(a <= b);
end
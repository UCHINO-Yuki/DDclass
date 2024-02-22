function c = ge(a,b)
% GE   Determine greater than or equal to.
%
%   See also GE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

c1 = a.v1 > b.v1;
c2 = a.v1 == b.v1;
c2(c2) = c2(c2) & (a.v2(c2) >= b.v2(c2));
c = c1 | c2;
end
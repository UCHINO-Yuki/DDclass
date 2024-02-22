function c = ne(a,b)
% NE    Determine inequality.
%
%   See also NE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd
end

c = a.v1 ~= b.v1 | a.v2 ~= b.v2;
end
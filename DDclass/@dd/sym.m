function c = sym(a,flag)
% SYM   Create symbolic variables, matrices.
%
%   See also SYM
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    flag (1,1) char {mustBeMember(flag,['r','d','e','f'])} = 'r'
end

c = sym(a.v1,flag) + sym(a.v2,flag);
end
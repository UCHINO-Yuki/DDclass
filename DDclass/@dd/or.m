function c = or(a,b)
% OR  Find logical or.
%
%   See also OR
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a double
    b double
end

c = a.v1 | b.v1;
end
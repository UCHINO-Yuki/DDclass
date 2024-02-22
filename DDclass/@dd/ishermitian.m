function c = ishermitian(a,skewOption)
% ISHERMITIAN   Determine if matrix is Hermitian or skew-Hermitian.
%
%   See also ISHERMITIAN
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a DD
    skewOption string {mustBeMember(skewOption,["skew","nonskew"])} = "nonskew"
end
if nargin == 1
    c = ishermitian(a.v1) & ishermitian(a.v2);
else
    c = ishermitian(a.v1,skewOption) & ishermitian(a.v2,skewOption);
end
end
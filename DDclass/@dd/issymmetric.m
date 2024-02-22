function c = issymmetric(a,skewOption)
% ISSYMMETRIC   Determine if matrix is symmetric or skew-symmetric.
%
%   See also ISSYMMETRIC
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    skewOption string {mustBeMember(skewOption,["skew","nonskew"])} = "nonskew"
end
if nargin == 1
    c = issymmetric(a.v1) & issymmetric(a.v2);
else
    c = issymmetric(a.v1,skewOption) & issymmetric(a.v2,skewOption);
end
end
function c = colon(a,m,b)
% COLON  Vector creation, array subscripting, and for-loop iteration
%
%   See also COLON
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    m dd
    b dd = []
end

if nargin == 2
    c = a + (0:double(floor(m-a)));
else
    c = a + (0:double(floor((b-a)./m))).*m;
end

end


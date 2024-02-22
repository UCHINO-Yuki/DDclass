function c = sparse(in1,in2,in3,in4,in5,in6)
% SPARSE    Create sparse matrix.
%
%   See also SPARSE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    in1 dd
    in2 double = []
    in3 dd = []
    in4 double = []
    in5 double = []
    in6 double = []
end
switch nargin
    case 1
        % S = sparse(A)
        c = dd(sparse(in1.v1),sparse(in1.v2),"no");
    case 2
        % S = sparse(m,n)
        c = dd(sparse(in1.v1,in2),sparse(in1.v1,in2),"no");
    case 3
        % S = sparse(i,j,v)
        c = dd(sparse(in1.v1,in2,in3.v1),sparse(in1.v1,in2,in3.v2),"no");
    case 5
        % S = sparse(i,j,v,m,n)
        c = dd(sparse(in1.v1,in2,in3.v1,in4,in5),sparse(in1.v1,in2,in3.v2,in4,in5),"no");
    case 6
        % S = sparse(i,j,v,m,n,nz)
        c = dd(sparse(in1.v1,in2,in3.v1,in4,in5,in6),sparse(in1.v1,in2,in3.v2,in4,in5,in6),"no");
    otherwise
        error('invalid input');
end
end
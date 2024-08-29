function [rA,rA2] = OzakiSplit(A,side,p,q)
% OZAKISPLIT    Split matrix into dd.numSplit matrices
%
%   based on the followings:
%       K. Ozaki et al.:
%       Error-free transformations of matrix multiplication by using fast
%       routines of matrix multiplication and its applications, 
%       Numerical Algorithms 59 (2012): 95-118.
%   
%       M. Lange and S.M. Rump:
%       An alternative approach to Ozaki's scheme for error-free transformation
%       of matrix multiplication, 
%       in International Workshop on Reliable Computing and Computer-Assisted
%       Proofs (2022)
% 
%       A. Minamihata et al.:
%       Improved extraction scheme for accurate floating-point summation,
%       in The 35th JSST Annual Conference International Conference on
%       Simulation Technology (2016)
%
%   written ... 2024-02-23 ... UCHINO Yuki

A1 = A.v1;
A2 = A.v2;

if strcmp(side,'left')
    dim = 2;
else
    dim = 1;
end
n = size(A1,dim);

i = 0;
s1 = 1-pow2(ceil(0.5*n + 1),-53);
s2 = 1-pow2(ceil(pow2(sqrt(n),-q-1)),-53);
s3 = 1+pow2(-52);
if ~any(A1,'all')
    rA{1} = A1;
    rA2{1} = A1;
end
while any(A1,'all')
    i = i+1;
    if i == p
        break;
    end
    rA2{i} = A1;
    x = vecnorm(A1,2,dim);
    mu = (((x./s2).*s3)./s1).*s3;
    t = pow2(0.75,nextpow2(mu)+q);% 0.75 * 2^(nextpow2(mu)+q-1)
    rA{i} = (A1+t)-t;
    A1 = A1-rA{i};
    [A1,A2] = FastTwoSum(A1,A2);
end
if any(A1,'all')
    rA{p} = A1;
end

end
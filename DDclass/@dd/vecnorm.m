function N = vecnorm(a,p,dim)
% VECNORM   Vector-wise norm.
%
%   See also VECNORM
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-06 ... UCHINO Yuki

arguments (Input)
    a dd
    p (1,1) double {mustBePositive} = 2
    dim double {mustBePositive} = 1
end

nd = ndims(a.v1);
mustBeMember(dim,1:nd);

if nd<dim
    N = abs(a);
    return;
end

if size(a.v1,1) == 1
    dim = 2;
end

if size(a.v1,dim) == 1
    N = abs(a);
    return;
end

if isempty(a)
    N = dd(vecnorm(a.v1,p,dim));
    return;
end

if p == 1
    B = abs(a);
    N = sum(B,dim);
elseif isinf(p)
    B = abs(a);
    N = max(B,[],dim);
elseif p==2
    N = sum(a.*a,dim);
    N = sqrt(N);
else
    B = abs(a);
    B = power(B,p);
    N = sum(B,dim);
    N = nthroot(N,p);
end

end
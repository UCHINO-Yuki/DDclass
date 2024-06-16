function [N,cnt] = normest(a,tol)
% NORMEST   2-norm estimate.
%
%   See also NORMEST
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-06 ... UCHINO Yuki
%   revised ... 2024-06-13 ... UCHINO Yuki

arguments (Input)
    a (:,:) dd
    tol (1,1) double {mustBePositive} = 1.e-32
end

if isempty(a)
    [N,cnt] = normest(a.v1,tol);
    return;
end

cnt = 0;
maxiter = 600; % set max number of iterations to avoid infinite loop

b = a.'*a;
[x,N_x] = eigs(b.v1,1);
x = dd(x); N_x = dd(N_x);
% x = vecnorm(a,1,1)';
% N_x = vecnorm(x);
N = N_x;
if N.v1 == 0
    return;
end

while 1
    N_old = N;
    x = x./N_x;
    Ax = a*x;
    % if nnz(Ax) == 0
    %     Ax = dd.rand(size(Ax));
    % end
    x = b*x;
    N_x = vecnorm(x);
    N = N_x./vecnorm(Ax);
    if abs(double(N-N_old)) <= tol*N.v1
        break;
    end
    cnt = cnt+1;
    if cnt > maxiter
        warning('dd_class: normest: notconverge');
        break;
    end
end
end

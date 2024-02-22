function [X,dD,nE,R,F,p] = RefSyEv2(A,X)
% REFSYEV2  Iterative refinement for symmetric EVD
%
%   based on the following:
%       Y. Uchino, K. Ozaki, T. Ogita: 
%       Acceleration of Iterative Refinement for Symmetric Eigenvalue
%       Decomposition (in Japanese),
%       IPSJ Transactions on Advanced Computing System,
%       vol. 15, no. 1, pp. 1-12, 2022.
%
%   written ... 2024-02-23 ... UCHINO Yuki

[k,n] = size(X.v1);                             % size of X
p_old = dd.numSplit(5);                         % #split for Ozaki's scheme
type = class(X.v1);                             % 'double' or 'gpuArray'

AX = A*X;                                       % in higher-prec.
dS = sum(X.*AX);                                % diag(X'*A*X)'
dR = sum(X.*X);                                 % diag(X'*X)'
dDT = dS./dR;                                   % approx. eigenvalues
Ddif = dDT-dDT.';                               % Ddif(i,j) := dD(j)-dD(i)
T = AX-X.*dDT;                                  % residual
F = dd(X.v1.'*T.v1);                            % X'*residual in lower-prec.

omega = 4*norm(T.v1,1)/sqrt(k);                 % identifier for non-clustered eigenvalues
nonCL = (abs(Ddif.v1) > omega);                 % index for non-clustered eigenvalues
p = [false; ~diag(nonCL,-1); false];
J = find(p(2:end)|p(1:end-1));                  % dD(J) are clustered
Y = X(:,J);
R = Y.'*Y;
E = zeros(n,type);
E(J,J) = double(eye(length(J),type)-R) .* 0.5;
tmp = F(nonCL)./Ddif(nonCL);
E(nonCL) = tmp.v1;
E(1:n+1:n*n) = double(1-dR).*0.5;

X = X + X.v1*E;                                 % update X
if nargout>2
    nE = 2.*norm(E,'fro')./sqrt(n);
end
dD = dDT.';

dd.numSplit(p_old);
end

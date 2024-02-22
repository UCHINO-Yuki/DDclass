function [U,V,nR] = RefSVD5_2(A,U,V)
% REFSVD5_2  Iterative refinement for SVD
%
%   based on the following:
%       Y. Uchino, T. Terao, K. Ozaki:
%       Acceleration of iterative refinement for singular value decomposition,
%       Numerical Algorithms (2023), in press,
%       https://doi.org/10.1007/s11075-023-01596-9.
%
%   written ... 2024-02-23 ... UCHINO Yuki

[Am,An] = size(A.v1);
n = size(V.v1,2);
p_old = dd.numSplit(5);                 % #split for Ozaki's scheme
type = class(U.v1);                     % 'double' or 'gpuArray'

AV = A*V;								% A*V in higher-prec.
AU = A.'*U;  							% A'*U in higher-prec.
dS = sum(U.*AV);					    % diag(U'*A*V)
dR = ldexp_(sum(U.*U)+sum(V.*V),0.5);   % diag(U'*U+V'*V)./2
sigmaT = dS./dR;    					% approximate singular values
sigma = sigmaT.';

% A*X-X*D =: [Z1, -Z1;
%             Z2,  Z2]
Z1 = AU-V.*sigmaT;						% residual P1 := A'*U-V*diag(sigma)
Z2 = AV-U.*sigmaT;						% residual P2 := A*V-U*diag(sigma)

% X'*(A*X-X*D) =: [F1, -F2;
%                  F2, -F1]
VZ1 = dd(0.5.*(V.v1.'*Z1.v1));			% V'*P1 in lower-prec.
U1Z2 = dd(0.5.*(U.v1.'*Z2.v1));	    	% U'*P2 in lower-prec.
F1 = VZ1+U1Z2;
E2 = VZ1-U1Z2;

% omega := 4*norm(Z,1)/sqrt(m+n)
n1 = sum(abs(Z1.v1),1);
n2 = sum(abs(Z2.v1),1);
nP1 = max(n1+n2)/sqrt(2);               % norm([Z1;Z2]/sqrt(2),1)
omega = 4*nP1/sqrt(Am+An);

% E =: [E1  E2;
%       E2  E1]
Sdif = sigmaT-sigma;                    % Sdif(i,j) := sigma(j)-sigma(i)
nonCL = (abs(Sdif.v1) > omega);         % index for non-clustered singular values
p = [false; ~diag(nonCL,-1); false];
J = find(p(2:end)|p(1:end-1));          % sigma(J) are clustered
Utmp = U(:,J);
Vtmp = V(:,J);
R = Utmp.'*Utmp + Vtmp.'*Vtmp;          % X(:,J)'*X(:,J)*2
E1 = dd.zeros(n,type);
E1(J,J) = ldexp_(eye(length(J),type)-ldexp_(R,0.5),0.5);   % E1(J,J) := (I-X(:,J)'*X(:,J))/2
E1(nonCL) = F1(nonCL)./Sdif(nonCL);     % E1(i,j) := Q1(i,j)/(sigma(j)-sigma(i))
E1(1:n+1:n*n) = ldexp_(1-dR,0.5);       % E1(i,i) := (1-dR(i))/2
E2 = E2./(sigmaT+sigma);                % E2(i,j) := Q1(i,j)/(sigma(j)+sigma(i))

% X := X+X*E
U = U+U.v1*double(E1-E2);			    % update U
V = V+V.v1*double(E1+E2);				% update V

nR = max( norm(Z1.v1,'fro') , norm(Z2.v1,'fro') );
dd.numSplit(p_old);
end

function [X,dD,nE] = RefSyEvCL2(A,X)
% REFSYEVCL2    Iterative refinement for symmetric EVD with clustered eigenvalues
%
%   based on the following:
%       T. Ogita, K. Aishima: 
%       Iterative refinement for symmetric eigenvalue decomposition II:
%       clustered eigenvalues,
%       Japan Journal of Industrial and Applied Mathematics,
%       vol. 36, no. 2, pp. 435-459, 2019.
%
%   written ... 2024-02-23 ... UCHINO Yuki

[X,dD,nE,R,F,p] = RefSyEv2(A,X);
n = size(X.v1,1);
[Jbegin,Jend,nJ] = IndexSets(p);
N = Jend-Jbegin+1;
p_old = dd.numSplit(5);                 % #split for Ozaki's scheme

for k=1:nJ
    i = Jbegin(k);
    j = Jend(k);
    J = i:j;                            % D(J) are clustered

    % Ak := A-muk*I
    muk = median(dD.v1(J));
    Ak = A;
    Ak(1:n+1:n*n) = diag(Ak)-muk;

    % update X
    Vk = X(:,J);
    I = sum(N(1:k-1))+1:sum(N(1:k));
    Tk = F(J,J)+R(I,I).*(dD(J)-muk)';   % Tk := Vk'*Ak*Vk
    dTk = (Tk.v1+Tk.v1')*0.5;
    [Wk,~] = eig(dTk);
    Vk = Vk*Wk;

    for iter = 1:10
        [Vk,~,nEk] = RefSyEv2(Ak,Vk);
        if nEk <= nE
            break
        end
    end
    X(:,J) = Vk;
end

dd.numSplit(p_old);
end

function [U,sigma,V,nR] = RefSVDCL(A,U,V)
% REFSVDCL  Iterative refinement for SVD with clustered singular values
%
%   based on the following:
%       T. Ogita, K. Aishima: 
%       Iterative refinement for symmetric eigenvalue decomposition II:
%       clustered eigenvalues,
%       Japan Journal of Industrial and Applied Mathematics,
%       vol. 36, no. 2, pp. 435-459, 2019.
%
%   written ... 2024-02-23 ... UCHINO Yuki

[U,sigma,V,nR,Fu,Fv,R,p] = RefSVD5(A,U,V);
p_old = dd.numSplit(5);                         % #split for Ozaki's scheme
[Jbegin,Jend,nJ] = IndexSets(p);
N = Jend-Jbegin+1;
cN = cumsum([0;N]);

for k=1:nJ
    i = Jbegin(k);
    j = Jend(k);
    J = i:j;                                    % D(J) are clustered
    
    muk = median(sigma.v1(J));

    % Tk := X(:,J)'*(B-muk*I)*X(:,J)
    Uk = U(:,J);
    Vk = V(:,J);
    % I = sum(N(1:k-1))+1:sum(N(1:k));
    I = cN(k)+1:cN(k+1);
    Tk = Fu(J,J) + Fv(J,J) + R(I,I).*(sigma(J)-muk).';
    dTk = 0.25 .* (Tk.v1 + Tk.v1.');
    [Wk,~] = eig(dTk);
    Uk = Uk * Wk;
    Vk = Vk * Wk;

    for iter = 1:10
        [Uk,Vk,nRk] = RefSVD5_2(A,Uk,Vk);
        if nRk <= nR
            break
        end
    end
    U(:,J) = Uk;
    V(:,J) = Vk;
end

dd.numSplit(p_old);
end

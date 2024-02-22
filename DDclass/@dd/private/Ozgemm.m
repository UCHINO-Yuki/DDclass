function C = Ozgemm(rA,rB,rB2)
% OZGEMM    Higher-precision matrix multiplication using dgemm
%
%   based on the following:
%       K. Ozaki, et al.:
%       Error-free transformations of matrix multiplication by using fast
%       routines of matrix multiplication and its applications, 
%       Numerical Algorithms 59 (2012): 95-118.
%
%   written ... 2024-02-23 ... UCHINO Yuki

nA = length(rA);
nB = length(rB);
p = dd.numSplit;
if isinf(p)
    p = nA+nB;
end

%% error-free part
tmpC = rA{1}*rB{1};
C = dd(tmpC);
for k=3:p
    flag = 0;
    % D = dd.zeros(m,n,'like',D);
    for i=1:nA
        for j=1:nB
            if i+j==k
                if flag == 0
                    D1 = rA{i}*rB{j};
                elseif flag == 1
                    D = dd(D1,rA{i}*rB{j});
                else
                    D = D+rA{i}*rB{j};
                end
                flag = flag + 1;
            end
        end
    end
    if flag == 1
        C = C+dd(D1);
    elseif flag > 1
        C = C+D;
    end
end

if nA+nB<=p
    return
end

%% other part
kA = p+1-nB;
kB = nB;
D = dd(rA{kA}*rB{kB});
for i=kA+1:nA
    kB = kB-1;
    D = D+rA{i}*rB2{kB};
end
C = C+D;

end
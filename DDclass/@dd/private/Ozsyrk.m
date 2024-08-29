function C = Ozsyrk(rA,rA2)
% OZSYRK    Higher-precision matrix multiplication using dsyrk
%
%   based on the followings:
%       K. Ozaki, et al.:
%       Error-free transformations of matrix multiplication by using fast
%       routines of matrix multiplication and its applications, 
%       Numerical Algorithms 59 (2012): 95-118.
%
%       Y. Uchino and K. Ozaki:
%       Fast and accurate symmetric rank-k operation,
%       in The 42nd JSST Annual Conference International Conference on
%       Simulation Technology (2023)
%
%   written ... 2024-02-23 ... UCHINO Yuki

nA = length(rA);
n_split = dd.numSplit;
[m,n] = size(rA{1});
Z = zeros(n,'like',rA{1});

if isinf(n_split)
    n_split = 2*nA;
    C = dd(rA{1}'*rA{1},Z,"no");
    for i=3:n_split
        qmax = floor((i-1)/2);
        D = dd(Z,Z,"no");
        for p=1:nA
            for q=1:qmax
                if p+q == i
                    E = rA{p}.'*rA{q};
                    D = D+(dd(E) + E.');
                end
            end
        end
        if mod(i,2)==0
            D = D+rA{i/2}.'*rA{i/2};
        end
        C = C+D;
    end
    return;
end

%% error-free part
C = dd(rA{1}'*rA{1},Z,"no");
for i=3:min(2*nA,n_split)
    qmax = floor((i-1)/2);
    D = dd(Z,Z,"no");
    for p=1:nA
        for q=1:qmax
            if p+q == i
                E = rA{p}.'*rA{q};
                D = D+(dd(E) + E.');
            end
        end
    end
    if mod(i,2)==0
        D = D+rA{i/2}.'*rA{i/2};
    end
    C = C+D;
end

%% pyramid
E = zeros(m,n);
i = floor((n_split+1)/2)+1;
for p = i:nA
    q = n_split+1-p;
    if q > nA
        continue;
    end
    E = E+rA{q};
    D = rA{p}.'*E;
    C = C+D;
    C = C+D';
end

%% big square part
if n_split==2
    if nA>=2
        C = C+rA{2}.'*rA{2};
    end
else
    i = floor(n_split/2)+1;
    if i <= nA
        C = C+rA2{i}.'*rA2{i};
    end
end

C.v1 = (C.v1 + C.v1.').*0.5;
C.v2 = (C.v2 + C.v2.').*0.5;

end
function c = mtimes(a,b)
% MTIMES    Matrix multiplication
%
%   See also MTIMES
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments
    a (:,:) dd
    b (:,:) dd
end

sizeA = size(a.v1);
sizeB = size(b.v1);

if isscalar(a.v1) || isscalar(b.v1)
    c = times(a,b);
    return;
end

if sizeA(2)~=sizeB(1)
    error('Arrays have incompatible sizes for this operation.');
end

if isempty(a.v1) || isempty(b.v1)
    c = dd(a.v1*b.v1);  % empty
    return
end

if dd.numSplit == 1
    if isequaln(a.v1,b.v1.')
        c = dd(b.v1.'*b.v1); % call dsyrk
    else
        c = dd(a.v1*b.v1);
    end
    return
end

% b(:,j) is finite
j = all(isfinite(b.v1),1);
allj = all(j);

if isequaln(a,b.')
    % c := b.' * b

    if allj
        % all elements of c := b.'*b are finite

        % rB{1}+...+rB{d} := b, d<=dd.numSplit
        % rB2{i} := B-rB{i-1}, where rB{0}:=O
        [rB,rB2] = OzakiSplit(b,'right',dd.numSplit,27);

        % c := (rB{1}+...+rB{d}).'*(rB{1}+...+rB{d})
        c = Ozsyrk(rB,rB2);
        return
    end

    % c := b.'*b has infinite elements or NaN
    c = (b.v1.'*b.v1);

    % rB{1}+...+rB{d} := b(:,j), d<=dd.numSplit
    % rB2{i} := B-rB{i-1}, where rB{0}:=O
    [rB,rB2] = OzakiSplit(b(:,j),'right',dd.numSplit,27);

    % use higher-prec. algorithm for only the finite elements
    c(j,j) = Ozsyrk(rB,rB2);

else
    % c := a * b

    % a(i,:) is finite
    i = all(isfinite(a.v1),2);
    alli = all(i);

    if alli
        % rA{1}+...+rA{d} := a, d<=dd.numSplit
        rA = OzakiSplit(a,'left',dd.numSplit,26);
    else
        % rA{1}+...+rA{d} := a(i,:), d<=dd.numSplit
        rA = OzakiSplit(a(i,:),'left',dd.numSplit,26);
    end

    if allj
        % rB{1}+...+rB{d} := b, d<=dd.numSplit
        % rB2{i} := B-rB{i-1}, where rB{0}:=O
        [rB,rB2] = OzakiSplit(b,'right',dd.numSplit,27);
    else
        % rB{1}+...+rB{d} := b(:,j), d<=dd.numSplit
        % rB2{i} := B-rB{i-1}, where rB{0}:=O
        [rB,rB2] = OzakiSplit(b(:,j),'right',dd.numSplit,27);
    end

    if alli && allj
        % all elements of c := a*b are finite

        % c := (rA{1}+...+rA{d})*(rB{1}+...+rB{d})
        c = Ozgemm(rA,rB,rB2);
        return
    end

    % c := a*b has infinite elements or NaN
    c = dd(a.v1*b.v1);

    % use higher-prec. algorithm for only the finite elements
    c(i,j) = Ozgemm(rA,rB,rB2);

end

end


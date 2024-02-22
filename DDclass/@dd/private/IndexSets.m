function [Jbegin,Jend,nJ] = IndexSets(p)
% INDEXSETS     Find the index sets for clustered eigenvalues and singular values.
%
%   written ... 2024-02-23 ... UCHINO Yuki

Jbegin = find(p(2:end) & ~p(1:end-1));
Jend = find(~p(2:end) & p(1:end-1));
nJ = length(Jbegin);
end
function c = parenReference(a,indexOp)
% PARENREFERENCE    Customize handling of object index references that begin with parentheses
%
%   See also PARENREFERENCE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    indexOp (1,1) matlab.indexing.IndexingOperation
end

c = dd(a.v1(indexOp.Indices{:}),a.v2(indexOp.Indices{:}),"no");
end
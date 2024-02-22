function a = parenAssign(a,indexOp,b)
% PARENASSIGN   Customize handling of object index assignments that begin with parentheses
%
%   See also PARENASSIGN
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    indexOp (1,1) matlab.indexing.IndexingOperation
    b dd
end

a.v1(indexOp.Indices{:}) = b.v1;
a.v2(indexOp.Indices{:}) = b.v2;
end
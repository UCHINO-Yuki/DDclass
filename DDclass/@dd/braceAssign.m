function a = braceAssign(a,indexOp,b)
% BRACEASSIGN   Customize handling of object index assignments that begin with braces
%
%   See also BRACEASSIGN
%
%   written ... 2024-09-18 ... UCHINO Yuki

arguments (Input)
    a dd
    indexOp (1,1) matlab.indexing.IndexingOperation
    b dd
end

a.v1(indexOp.Indices{:}) = b.v1;
a.v2(indexOp.Indices{:}) = b.v2;
end
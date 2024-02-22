function c = dotReference(a,indexOp)
% DOTREFERENCE  Customize handling of object index references that begin with dots.
%   
%   c = a.v1(_)
%   c = a.v2(_)
%   
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd 
    indexOp matlab.indexing.IndexingOperation
end

n = numel(indexOp);
mustBeMember(indexOp(1).Name,{'v1','v2'});
if n==1
    c = a.(indexOp.Name);
    return
elseif n==2
    if strcmp(indexOp(2).Type,'Paren')
        c = a.(indexOp(1).Name)(indexOp(2).Indices{:});
        return
    end
end
error('Invalid referencing.');
end
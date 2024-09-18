function varargout = braceReference(a,indexOp)
% BRACEREFERENCE    Customize handling of object index references that begin with braces
%
%   See also BRACEREFERENCE
%
%   written ... 2024-09-18 ... UCHINO Yuki

arguments (Input)
    a dd
    indexOp matlab.indexing.IndexingOperation
end

n = numel(indexOp);
colonflag = strcmp(indexOp(1).Indices{1},':');

if n==1

    if colonflag
        varargout{2} = a.v2;
        varargout{1} = a.v1;
        return
    elseif isvector(indexOp(1).Indices{1}) ...
            && all(indexOp(1).Indices{1} >= 1) ...
            && all(indexOp(1).Indices{1} <= 2)
        if isscalar(indexOp.Indices{1})
            varargout{1} = a.("v"+indexOp.Indices{1}(1));
            return
        else
            varargout{2} = a.("v"+indexOp.Indices{1}(2));
            varargout{1} = a.("v"+indexOp.Indices{1}(1));
            return
        end
    end

elseif n==2 && strcmp(indexOp(2).Type,'Paren') && ~colonflag

    if isscalar(indexOp(1).Indices{1}) ...
            && indexOp(1).Indices{1} >= 1 ...
            && indexOp(1).Indices{1} <= 2
        varargout{1} = a.("v"+indexOp(1).Indices{1}(1))(indexOp(2).Indices{:});
        return
    end

end
error('Invalid referencing.');

end
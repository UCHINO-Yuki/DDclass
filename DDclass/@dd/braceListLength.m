function n = braceListLength(~,indexOp,~)
% BRACELISTLENGTH   Number of values to return from indexing operation
%
%   See also BRACELISTLENGTH
%
%   written ... 2024-09-18 ... UCHINO Yuki

if strcmp(indexOp(1).Indices{1},':')
    n = 2;
else
    n = length(indexOp(1).Indices{1});
end

end
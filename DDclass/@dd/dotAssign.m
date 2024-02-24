function a = dotAssign(a,indexOp,b)
% DOTASSIGN  Customize handling of object index assignments that begin with dots.
%   
%   a._ = b
%   
%   written ... 2024-02-25 ... UCHINO Yuki

error('Index assignments that begin with braces are not supported for dd.');
end
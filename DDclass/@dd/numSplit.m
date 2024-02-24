function out = numSplit(k)
% NUMSPLIT  Set the accurary of matrix multiplications.
%
%   This value affects the accuracy of mtimes. 
%   The larger the value, the more accurate the computation.
%   The lower the value, the faster the computation speed.
%
%   DD.numSplit(k_new)          sets the value. The default is 5.
%   k_old = DD.numSplit         returns the current value.
%   k_old = DD.numSplit(k_new)  sets new value and returns the current value.
%
%   The input argument must be real integer scalar.
%
%   written ... 2024-02-25 ... UCHINO Yuki

arguments (Input)
    k double {mustBeScalarOrEmpty,mustBeInteger} = []
end
persistent Var;
if isempty(Var)
    Var = 5;
end
out = Var;
if nargin
    if ~isempty(k)
        Var = k;
    end
end

end
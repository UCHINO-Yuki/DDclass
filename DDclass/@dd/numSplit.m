function out = numSplit(k)
% NUMSPLIT  Set the accurary of matrix multiplications.
%
%   This value affects the accuracy of mtimes. 
%   The larger the value, the more accurate the computation.
%   The lower the value, the faster the computation speed.
%
%   dd.numSplit(k_new)          sets the value. The default is 5.
%   k_old = dd.numSplit         returns the current value.
%   k_old = dd.numSplit(k_new)  sets new value and returns the current value.
%
%   The input argument must be real positive integer scalar.
%
%   See also DD
%
%   written ... 2024-02-25 ... UCHINO Yuki
%   revised ... 2024-03-05 ... UCHINO Yuki
%   revised ... 2024-03-30 ... UCHINO Yuki

arguments (Input)
    k double {mustBeScalarOrEmpty,mustBeInteger,mustBePositive} = []
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
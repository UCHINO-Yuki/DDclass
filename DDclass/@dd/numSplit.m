function out = numSplit(k)
% NUMSPLIT  Change maximum number of split matrices for Ozaki's scheme.
%
%   This value affects the accuracy of mtimes. 
%   The larger the value, the more accurate the computation.
%   The lower the value, the faster the computation speed.
%
%   dd.NUMSPLIT(k_new)         sets the value. The default is 5.
%   k_old = dd.NUMSPLIT        returns the current value
%   k_old = dd.NUMSPLIT(k_new) sets new value and returns the current value
%   
%   The input argument must be real integer scalar.
%
%   written ... 2024-02-23 ... UCHINO Yuki

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
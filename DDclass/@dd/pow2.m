function a = pow2(a,p)
% POW2    Base 2 exponentiation and scaling of floating-point numbers.
%
%   See also POW2
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments
    a dd
    p double {mustBeReal} = 1
end

if nargin == 1
    if isempty(a)
        return;
    end

    % B := 2.^A
    a = exp(a.*dd.ddlog2);
    return;
end

% B := A .* 2.^round(p)
if isequal(size(a.v1),size(p)) || (isscalar(p) && ~isempty(a.v1))
    a.v1 = pow2(a.v1,p);
    a.v2 = pow2(a.v2,p);
else
    error('Arrays have incompatible sizes for this function.')
end
end
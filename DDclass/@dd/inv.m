function c = inv(a)
% INV    Matrix inverse.
%
%   See also INV
%
%   written ... 2024-03-04 ... UCHINO Yuki

arguments (Input)
    a (:,:) dd
end

n = size(a.v1,1);
if n ~= size(a.v1,2)
    error('Matrix must be square.');
end

if isempty(a.v1)
    c = a;
    return;
end

if isscalar(a.v1)
    c = 1./a;
    return;
end

% initial guess
c1 = dd(inv(a.v1));

% Newton-Schulz iter.
for i=1:10
    r = -a*c1;                      % -a*inv(a)
    r(1:n+1:n*n) = r(1:n+1:n*n)+1;  % I-a*inv(a)
    c = c1 + c1.v1*r.v1;            % update inv(a)
    if ~any(double(c-c1),'all')
        break;                      % converged
    end
    c1 = c;
end

end
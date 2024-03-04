function c = mldivide(a,b)
% MLDIVIDE  Solve systems of linear equations Ax = B for x.
%
%   See also MLDIVIDE
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-04 ... UCHINO Yuki

arguments (Input)
    a (:,:) dd
    b (:,:) dd
end

if isscalar(a.v1) || isscalar(b.v1)
    c = a.\b;
    return;
end

szA = size(a.v1);
szB = size(b.v1);

if szA(1) ~= szB(1)
    error('Arrays have incompatible sizes for this operation.');
end

if isempty(a.v1) || isempty(b.v1)
    c = dd(a.v1\b.v1);
    return
end

if szA(1) ~= szA(2)
    % solve least square problem
    aa = a'*a;
    ab = a'*b;

    % initial guess
    c1 = dd(aa.v1\ab.v1);   % solve a*x = b

    % residual iter.
    for i=1:10
        r = ab-aa*c1;           % residual
        y = aa.v1\r.v1;         % solve a*y = r
        c = c1+y;               % update x
        if ~any(double(c-c1),'all')
            return;             % converged
        end
        c1 = c;
    end

end

% solve a*x = b
% initial guess
c1 = dd(a.v1\b.v1);  % solve a*x = b

% residual iter.
for i=1:10
    r = b-a*c1;             % residual
    y = a.v1\r.v1;          % solve a*y = r
    c = c1+y;               % update x
    if ~any(double(c-c1),'all')
        break;              % converged
    end
    c1 = c;
end

end
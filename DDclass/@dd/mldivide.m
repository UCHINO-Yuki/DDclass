function c = mldivide(a,b)
% MLDIVIDE  Solve systems of linear equations Ax = B for x.
%
%   See also MLDIVIDE
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments
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
    c = dd(aa.v1\ab.v1);  % solve a*x = b

    % 1st iter
    r = ab-aa*c;            % residual
    y = aa.v1\r.v1; % solve a*y = r
    c = c+y;                % update x

    % 2nd iter
    r = ab-aa*c;            % residual
    y = aa.v1\r.v1; % solve a*y = r
    c = c+y;                % update x
    return;
end

% solve a*x = b
% initial guess
c = dd(a.v1\b.v1);  % solve a*x = b

% 1st iter
r = b-a*c;              % residual
y = a.v1\r.v1;  % solve a*y = r
c = c+y;                % update x

% 2nd iter
r = b-a*c;              % residual
y = a.v1\r.v1;  % solve a*y = r
c = c+y;                % update x

end
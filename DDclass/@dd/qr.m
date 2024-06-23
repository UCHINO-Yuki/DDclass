function varargout = qr(a,in2)
% QR   QR decomposition
%
%   qr(a)
%   qr(a,"econ")
%   qr(a,0)
%
%   See also QR
%
%   written ... 2024-06-22 ... UCHINO Yuki
%   revised ... 2024-06-23 ... UCHINO Yuki

arguments (Input)
    a (:,:) dd
    in2 = []
end

if nargout > 2
    error('Too many output.');
end

if nargout <= 1
    idxR = 1;
    idxQ = 2;
else
    idxQ = 1;
    idxR = 2;
end

if nargin == 2
    if isnumeric(in2)
        if in2 ~= 0
            error('invalid input.');
        end
    else 
        if ~strcmp(in2,"econ")
            error('invalid input.');
        end
    end
end

if isempty(a)
    varargout{1} = dd.empty;
    varargout{2} = dd.empty;
    return;
end

MN = size(a);

% initial guess
[dq,~] = qr(a.v1);
q = dd(dq);

% re-orthogonalization
e = q.'*q;
n = size(e,1);
e(1:n+1:end) = e(1:n+1:end) - 1;
q = q - 0.5 * q.v1 * e.v1;

% for remainder part
r = q'*a;
[dq,~] = qr(r.v1);
q = q*dq;

% re-orthogonalization
e = q.'*q;
e(1:n+1:end) = e(1:n+1:end) - 1;
q = q - 0.5 * q.v1 * e.v1;

if isempty(in2)
    varargout{idxQ} = q;
    if MN(2)<MN(1)
        varargout{idxR} = [triu(q(:,1:MN(2))'*a); zeros(MN(1)-MN(2))];
    else
        varargout{idxR} = triu(q'*a);
    end
else
    minMN = min(MN);
    varargout{idxQ} = q(1:MN(1),1:minMN);
    varargout{idxR} = triu(varargout{idxQ}'*a(:,1:MN(2)));
end

end
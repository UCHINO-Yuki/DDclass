function [c,mpc] = mpower(a,b)
% MPOWER    Matrix power.
%
%   See also MPOWER
%
%   written ... 2024-03-05 ... UCHINO Yuki

arguments (Input)
    a (:,:) dd
    b (:,:) dd
end

%% a & b are scalar
if isscalar(a.v1) && isscalar(b.v1)
    c = a.^b;
    return
end

%% a & b must be square
sza = size(a.v1);
szb = size(b.v1);
if sza(1) ~= sza(2) || szb(1) ~= szb(2)
    error('Invalid input.');
end

%% A^b
% mpc = dd(mp(a)^mp(b));
if isscalar(b.v1)
    if isempty(a.v1)
        c = a;
        return
    end
    if b == round(b)
        c = mpower_integer(a,b.v1);
    else
        if issymmetric(a)
            [v,d] = eig(full(a),'vector');
            c = (v.*(d.^b).')*v.';
            if issparse(a)
                c = sparse(c);
            end
        else
            error('input matrix must be symmetric.')
        end
    end
    return
end

%% a^B
if isscalar(a.v1)
    if isempty(b.v1)
        c = b;
        return
    end
    if issymmetric(b)
        [v,d] = eig(full(b),'vector');
        c = (v.*(a.^d).')/v;
        if issparse(b)
            c = sparse(c);
        end
    else
        error('input matrix must be symmetric.')
    end
    return
end

error('Invalid input.');
end

%% A^i
function c = mpower_integer(a,i)
if i==0
    if anynan(a.v1)
        c = dd.nan(size(a.v1));
    else
        c = dd.eye(size(a.v1));
    end
elseif i==1
    c = a;
else
    ui = abs(i);
    if i<0
        a = inv(a);
    end
    first = true;
    while ui > 0
        if rem(ui,2) == 1 %if odd
            if first
                c = a;  % hit first time. D*I
                first = false;
            else
                c = a*c;
            end
        end
        ui = fix(ui/2);
        if ui ~= 0
            a = a*a;
        end
    end
end
end

function N = norm(a,p)
% NORM   Vector and matrix norms.
%
%   See also NORM
%
%   written ... 2024-02-23 ... UCHINO Yuki
%   revised ... 2024-03-06 ... UCHINO Yuki

arguments (Input)
    a dd
    p = 2
end

if isnumeric(p)
    if ~isscalar(p)
        error('Invalid input for norm.');
    end
    mustBeMember(p,[1,2,Inf]);
else
    mustBeMember(p,'fro');
end

if isvector(a)
    N = vecnorm(a,p);
    return
end

if ~ismatrix(a) && ~strcmp(p,"fro")
    error('The only norm available for N-D arrays is ''fro''.');
end

if isempty(a)
    N = dd(norm(a.v1,p));
    return;
end

switch p
    case 1
        a = abs(a);
        v = sum(a);
        [vmax,i] = max(v.v1);
        w = find(v.v1==vmax);
        if length(w) > 1
            [~,wi] = max(v.v2(w));
            i = w(wi);
        end
        k = i(1);
        N = dd(v.v1(k),v.v2(k),"no");
    case 2
        s = svd(a,'vector');
        N = max(s(1),s(end));
    case Inf
        a = abs(a);
        v = sum(a,2);
        [vmax,i] = max(v.v1);
        w = find(v.v1==vmax);
        if length(w) > 1
            [~,wi] = max(v.v2(w));
            i = w(wi);
        end
        k = i(1);
        N = dd(v.v1(k),v.v2(k),"no");
    case "fro"
        N = sqrt(sum(a.*a,'all'));
    otherwise
        error('error for norm');
end
end
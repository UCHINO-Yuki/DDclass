function varargout = svd(a,in2,in3)
% SVD    Singular value decomposition.
%
%   svd(a)
%   svd(a,econflag)
%   svd(a,outputform)
%   svd(a,econflag,outputform)
%
%   See also SVD
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a (:,:) dd
    in2 string {} = ""
    in3 string {mustBeMember(in3,["matrix","vector"])} = "matrix"
end

if nargout > 3
    error('Too many output.');
end

idxV = 3;
switch nargin
    case 1
        if nargout <= 1
            idxS = 1;
            idxU = 2;
            in3 = "vector";
        else
            idxU = 1;
            idxS = 2;
        end

    case 2
        if strcmp(in2,"0") || strcmp(in2,"econ")
            in2 = "econ";
            if nargout <= 1
                idxS = 1;
                idxU = 2;
                in3 = "vector";
            else
                idxU = 1;
                idxS = 2;
            end
        elseif strcmp(in2,"matrix") || strcmp(in2,"vector")
            in3 = in2;
            in2 = "";
            if nargout <= 1
                idxS = 1;
                idxU = 2;
            else
                idxU = 1;
                idxS = 2;
            end
        else
            error('invalid input.');
        end

    case 3
        if ~strcmp(in2,"0") && ~strcmp(in2,"econ")
            error('invalid input.');
        end
        if ~strcmp(in3,"matrix") && ~strcmp(in3,"vector")
            error('invalid input.');
        end
        in2 = "econ";
        if nargout <= 1
            idxS = 1;
            idxU = 2;
        else
            idxU = 1;
            idxS = 2;
        end
end

imax = 10;
[m,n] = size(a.v1);

%% a is empty
if isempty(a)
    varargout{idxS} = a;
    varargout{idxU} = dd.eye(m);
    varargout{idxV} = dd.eye(n);
    return
end

%% a is symmetric
if issymmetric(a)
    % standard evd
    [x,~] = eig(a.v1,'vector');
    varargout{idxU} = dd(x);
    for i=1:imax
        [varargout{idxU},tmpS,nE] = RefSyEvCL2(a,varargout{idxU});
        if nE <= 1.e-30
            break;
        end
        if i == imax
            warning('svd for dd: not converge');
        end
    end
    varargout{idxV} = varargout{idxU};
    if strcmp(in3,"matrix")
        varargout{idxS} = diag(tmpS);
    else
        varargout{idxS} = tmpS;
    end
    return
end

%% m < n
if m<n
    tmpA = a.';
    [dU,~,dV] = svd(tmpA.v1,"vector");
    tmpU = dd(dU);
    tmpV = dd(dV);
    for i=1:imax
        [tmpU,tmpS,tmpV,nR] = RefSVDCL(tmpA,tmpU,tmpV);
        if nR <= 1.e-30
            break;
        end
        if i == imax
            warning('svd for dd: not converge');
        end
    end

    varargout{idxU} = tmpV;
    if strcmp(in2,"econ")
        varargout{idxV} = tmpU(:,1:n);
        if strcmp(in3,"vector")
            varargout{idxS} = tmpS;
        else
            varargout{idxS} = diag(tmpS);
        end
    else
        varargout{idxV} = tmpU;
        if strcmp(in3,"vector")
            varargout{idxS} = tmpS;
        else
            varargout{idxS} = [diag(tmpS),zeros(m,n-m)];
        end
    end
    return
end

%% m >= n
[dU,~,dV] = svd(a.v1,"vector");
tmpU = dd(dU);
tmpV = dd(dV);
for i=1:imax
    [tmpU,tmpS,tmpV,nR] = RefSVDCL(a,tmpU,tmpV);
    if nR <= 1.e-30
        break;
    end
    if i == imax
        warning('svd for dd: not converge');
    end
end

varargout{idxV} = tmpV;
if strcmp(in2,"econ")
    varargout{idxU} = tmpU(:,1:n);
    if strcmp(in3,"vector")
        varargout{idxS} = tmpS;
    else
        varargout{idxS} = diag(tmpS);
    end
else
    varargout{idxU} = tmpU;
    if strcmp(in3,"vector")
        varargout{idxS} = tmpS;
    else
        varargout{idxS} = [diag(tmpS);zeros(m-n,n)];
    end
end

end
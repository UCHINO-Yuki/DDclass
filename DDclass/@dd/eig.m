function varargout = eig(a,in2,in3)
% EIG   Eigenvalues and eigenvectors
%
%   eig(a)
%   eig(a,outputForm)
%   eig(a,b)
%   eig(a,b,outputForm)
%
%   See also EIG
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a (:,:) dd
    in2 = []
    in3 string {mustBeMember(in3,["matrix","vector"])} = "matrix"
end

if ~issymmetric(a)
    error('input matrix must be symmetric.')
end

if nargout > 2
    error('Too many output.');
end

switch nargin
    case 1
        if nargout <= 1
            idxD = 1;
            idxX = 2;
            in3 = "vector";
        else
            idxX = 1;
            idxD = 2;
        end
        
    case 2
        if strcmp(in2,"matrix") || strcmp(in2,"vector")
            % eig(a,outputform) => eig(a,[],outputform)
            in3 = in2;
            in2 = [];
            if nargout <= 1
                idxD = 1;
                idxX = 2;
            else
                idxX = 1;
                idxD = 2;
            end

        elseif isnumeric(in2) || isUnderlyingType(in2,'sym')
            % eig(a,b) => eig(a,b,outputform)
            if ~isUnderlyingType(in2,"dd")
                in2 = dd(in2);
            end
            if ~issymmetric(in2)
                error('input matrix must be symmetric.');
            end
            mustBeReal(in2);
            if ~isequal(size(a.v1),size(in2.v1))
                error('For generalized eigenproblem, input matrices must be the same size.')
            end
            if nargout <= 1
                idxD = 1;
                idxX = 2;
                in3 = "vector";
            else
                idxX = 1;
                idxD = 2;
            end
        else
            error('invalid input.');
        end

    case 3
        % eig(a,b,outputform)
        if ~isnumeric(in2) && ~isUnderlyingType(in2,'sym')
            error('invalid input.');
        end
        mustBeReal(in2);
        if ~isUnderlyingType(in2,"dd")
            in2 = dd(in2);
        end
        if ~issymmetric(in2)
            error('input matrix must be symmetric.');
        end
        if ~isequal(size(a.v1),size(in2.v1))
            error('For generalized eigenproblem, input matrices must be the same size.')
        end
        mustBeMember(in3,["matrix","vector"]);
        if nargout <= 1
            idxD = 1;
            idxX = 2;
        else
            idxX = 1;
            idxD = 2;
        end
end

if isempty(a)
    varargout{1} = dd.empty;
    varargout{2} = dd.empty;
    return;
end

imax = 10;
if isempty(in2)
    % standard EVD
    [x,~] = eig(a.v1,'vector');
    varargout{idxX} = dd(x);
    for i=1:imax
        [varargout{idxX},tmpD,nE] = RefSyEvCL2(a,varargout{idxX});
        if nE <= 1.e-30
            break;
        end
        if i == imax
            warning('eig for dd: not converge');
        end
    end
else
    % Generalized EVD
    [x,~] = eig(a.v1,in2.v1,'vector');
    varargout{idxX} = dd(x);
    for i=1:imax
        [varargout{idxX},tmpD,nE] = RefSyEvGL2(a,in2,varargout{idxX});
        if nE <= 1.e-30
            break;
        end
        if i == imax
            warning('eig for dd: not converge');
        end
    end
end
if strcmp(in3,"matrix")
    varargout{idxD} = diag(tmpD);
else
    varargout{idxD} = tmpD;
end

end
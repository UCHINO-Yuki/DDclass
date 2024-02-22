function [m,i] = max(a,b,opt1,opt2,opt3,opt4,opt5)
% MAX   Maximum elements of array.
%
%   See also MAX
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    b dd = []
    opt1 (1,1) string = ""
    opt2 (1,1) string = ""
    opt3 (1,1) string = ""
    opt4 (1,1) string = ""
    opt5 (1,1) string = ""
end

%% initial flags
onlyA = true;
dim = 1;
linear = false;
omitnan = true;
compareabs = false;

%% Validate inputs
missingflaglist = ["omitmissing","omitnan","includemissing","includenan"];
methodlist = ["auto","real","abs"];
szb = size(b.v1);
switch nargin
    case 7
        % A: dd
        % B: []
        % opt1: "1", "2", or "all"
        % opt2: "linear"
        % opt3: missingflag
        % opt4: "ComparisonMethod"
        % opt5: method
        if ~isempty(b)...
                || any(szb ~= 0)...
                || ~ismember(opt1,["1","2","all"])...
                || ~strcmp(opt2,"linear")...
                || ~ismember(opt3,missingflaglist)...
                || ~strcmp(opt4,"ComparisonMethod")...
                || ~ismember(opt5,methodlist)
            error('Invalid input.');
        end
        dim = double(opt1);
        if isnan(dim)
            dim = "all";
        end
        if isempty(a)
            m = dd(max(a.v1,[],dim,opt2,opt3,opt4,opt5));
            i = m;
            return;
        end
        linear = true;
        if ismember(opt3,missingflaglist(3:4))
            omitnan = false;
        end
        if strcmp(opt5,methodlist(3))
            compareabs = true;
            tmpA = a;
            a = abs(a);
        end

    case 6
        if strcmp(opt1,"linear")
            % A: dd
            % B: []
            % opt1: "linear"
            % opt2: missingflag
            % opt3: "ComparisonMethod"
            % opt4: method
            if ~isempty(b)...
                    || any(szb ~= 0)...
                    || ~strcmp(opt1,"linear")...
                    || ~ismember(opt2,missingflaglist)...
                    || ~strcmp(opt3,"ComparisonMethod")...
                    || ~ismember(opt4,methodlist)
                error('Invalid input.');
            end
            if isempty(a)
                m = dd(max(a.v1,[],opt1,opt2,opt3,opt4));
                i = m;
                return;
            end
            linear = true;
            if ismember(opt2,missingflaglist(3:4))
                omitnan = false;
            end
            if strcmp(opt4,methodlist(3))
                compareabs = true;
                tmpA = a;
                a = abs(a);
            end

        else
            % A: dd
            % B: []
            % opt1: "1", "2", or "all"
            % opt2: missingflag
            % opt3: "ComparisonMethod"
            % opt4: method
            if ~isempty(b)...
                    || any(szb ~= 0)...
                    || ~ismember(opt1,["1","2","all"])...
                    || ~ismember(opt2,missingflaglist)...
                    || ~strcmp(opt3,"ComparisonMethod")...
                    || ~ismember(opt4,methodlist)
                error('Invalid input.');
            end
            dim = double(opt1);
            if isnan(dim)
                dim = "all";
            end
            if isempty(a)
                m = dd(max(a.v1,[],dim,opt2,opt3,opt4));
                i = m;
                return;
            end
            if ismember(opt2,missingflaglist(3:4))
                omitnan = false;
            end
            if strcmp(opt4,methodlist(3))
                compareabs = true;
                tmpA = a;
                a = abs(a);
            end

        end

    case 5
        if isempty(b) && all(szb == 0)
            if strcmp(opt1,"linear")
                % A: dd
                % B: []
                % opt1: "linear"
                % opt2: "ComparisonMethod"
                % opt3: method
                if ~strcmp(opt2,"ComparisonMethod")...
                        || ~ismember(opt3,methodlist)
                    error('Invalid input.');
                end
                if isempty(a)
                    m = dd(max(a.v1,[],opt1,opt2,opt3));
                    i = m;
                    return;
                end
                linear = true;
                if strcmp(opt3,methodlist(3))
                    compareabs = true;
                    tmpA = a;
                    a = abs(a);
                end

            elseif strcmp(opt2,"linear")
                % A: dd
                % B: []
                % opt1: "1", "2", or "all"
                % opt2: "linear"
                % opt3: missingflag
                if ~ismember(opt1,["1","2","all"])...
                        || ~ismember(opt3,missingflaglist)
                    error('Invalid input.');
                end
                dim = double(opt1);
                if isnan(dim)
                    dim = "all";
                end
                if isempty(a)
                    m = dd(max(a.v1,[],dim,opt2,opt3));
                    i = m;
                    return;
                end
                linear = true;
                if ismember(opt3,missingflaglist(3:4))
                    omitnan = false;
                end

            else
                % A: dd
                % B: []
                % opt1: "1", "2", or "all"
                % opt2: "ComparisonMethod"
                % opt3: method
                if ~ismember(opt1,["1","2","all"])...
                        || ~strcmp(opt2,"ComparisonMethod")...
                        || ~ismember(opt3,methodlist)
                    error('Invalid input.');
                end
                dim = double(opt1);
                if isnan(dim)
                    dim = "all";
                end
                if isempty(a)
                    m = dd(max(a.v1,[],dim,opt2,opt3));
                    i = m;
                    return;
                end
                if ismember(opt3,missingflaglist(3:4))
                    omitnan = false;
                end

            end
        else
            % A: dd
            % B: dd
            % opt1: missingflag
            % opt2: "ComparisonMethod"
            % opt3: method
            [flag,a,b] = sizeCheck(a,b);
            if flag
                error('Arrays have incompatible sizes for this operation.');
            end
            if isempty(b)
                % max(empty,empty)
                m = a;
                return;
            end
            if isempty(a)...
                    || ~ismember(opt1,missingflaglist)...
                    || ~strcmp(opt2,"ComparisonMethod")...
                    || ~ismember(opt3,methodlist)
                error('Invalid input.');
            end
            if nargout > 1
                error('Too many output.');
            end
            if isempty(a)
                m = dd(max(a.v1,[],opt1,opt2,opt3));
                i = m;
                return;
            end
            onlyA = false;
            if ismember(opt1,missingflaglist(3:4))
                omitnan = false;
            end
            if strcmp(opt3,methodlist(3))
                compareabs = true;
                tmpA = a;
                a = abs(a);
                tmpB = b;
                b = abs(b);
            end

        end

    case 4
        if isempty(b) && all(szb == 0)
            if strcmp(opt1,"ComparisonMethod")
                % A: dd
                % B: []
                % opt1: "ComparisonMethod"
                % opt2: method
                if ~ismember(opt2,methodlist)
                    error('Invalid input.');
                end
                if isempty(a)
                    m = dd(max(a.v1,[],opt1,opt2));
                    i = m;
                    return;
                end
                if strcmp(opt2,methodlist(3))
                    compareabs = true;
                    tmpA = a;
                    a = abs(a);
                    tmpB = b;
                    b = abs(b);
                end

            elseif strcmp(opt1,"linear")
                % A: dd
                % B: []
                % opt1: "linear"
                % opt2: missingflag
                if ~ismember(opt2,missingflaglist)
                    error('Invalid input.');
                end
                if isempty(a)
                    m = dd(max(a.v1,[],opt1,opt2));
                    i = m;
                    return;
                end
                linear = true;
                if ismember(opt2,missingflaglist(3:4))
                    omitnan = false;
                end

            elseif strcmp(opt2,"linear")
                % A: dd
                % B: []
                % opt1: "1", "2", or "all"
                % opt2: "linear"
                if ~ismember(opt1,["1","2","all"])
                    error('Invalid input.');
                end
                linear = true;
                dim = double(opt1);
                if isnan(dim)
                    dim = "all";
                end
                if isempty(a)
                    m = dd(max(a.v1,[],dim,opt2));
                    i = m;
                    return;
                end

            else
                % A: dd
                % B: []
                % opt1: "1", "2", "all"
                % opt2: missingflag
                if ~ismember(opt1,["1","2","all"])...
                        || ~ismember(opt2,missingflaglist)
                    error('Invalid input.');
                end
                dim = double(opt1);
                if isnan(dim)
                    dim = "all";
                end
                if isempty(a)
                    m = dd(max(a.v1,[],dim,opt2));
                    i = m;
                    return;
                end
                if ismember(opt2,missingflaglist(3:4))
                    omitnan = false;
                end

            end
        else
            % A: dd
            % B: dd
            % opt1: "ComparisonMethod"
            % opt2: method
            [flag,a,b] = sizeCheck(a,b);
            if flag
                error('Arrays have incompatible sizes for this operation.');
            end
            if isempty(b)
                % max(empty,empty)
                m = a;
                return;
            end
            if isempty(a)...
                    || ~strcmp(opt1,"ComparisonMethod")...
                    || ~ismember(opt2,methodlist)
                error('Invalid input.');
            end
            if nargout > 1
                error('Too many output.');
            end

            onlyA = false;
            if strcmp(opt2,methodlist(3))
                compareabs = true;
                tmpA = a;
                a = abs(a);
                tmpB = b;
                b = abs(b);
            end
        end

    case 3
        if isempty(b) && all(szb == 0)
            if strcmp(opt1,"linear")
                % A: dd
                % B: []
                % opt1: "linear"
                if isempty(a)
                    m = dd(max(a.v1,[],opt1));
                    i = m;
                    return;
                end
                linear = true;

            elseif ismember(opt1,["1","2","all"])
                % A: dd
                % B: []
                % opt1: "1", "2", or "all"
                dim = double(opt1);
                if isnan(dim)
                    dim = "all";
                end
                if isempty(a)
                    m = dd(max(a.v1,[],dim));
                    i = m;
                    return;
                end

            else
                % A: dd
                % B: []
                % opt1: missingflag
                if ~ismember(opt1,missingflaglist)
                    error('Invalid input.');
                end
                if isempty(a)
                    m = dd(max(a.v1,[],opt1));
                    i = m;
                    return;
                end
                if ismember(opt1,missingflaglist(3:4))
                    omitnan = false;
                end

            end
        else
            % A: dd
            % B: dd
            % opt1: missingflag
            [flag,a,b] = sizeCheck(a,b);
            if flag
                error('Arrays have incompatible sizes for this operation.');
            end
            if isempty(b)
                % max(empty,empty)
                m = a;
                return;
            end
            if isempty(a) || ~ismember(opt1,missingflaglist)
                error('Invalid input.');
            end
            if nargout > 1
                error('Too many output.');
            end

            onlyA = false;
            if ismember(opt1,missingflaglist(3:4))
                omitnan = false;
            end
        end

    case 2
        % A: dd
        % B: dd
        [flag,a,b] = sizeCheck(a,b);
        if flag
            error('Arrays have incompatible sizes for this operation.');
        end
        if isempty(b)
            if isempty(a)
                % max(empty,empty)
                m = a;
                return;
            else
                % max(A,[])
                error('Invalid input.');
            end
        elseif isempty(a)
            % max([],B)
            error('Invalid input.');
        end
        if nargout > 1
            error('Too many output.');
        end

        onlyA = false;

    case 1
        % A: dd
        if isempty(a)
            m = dd(max(a.v1));
            i = m;
            return;
        end

    otherwise
        error('Invalid input.');
end

%% kernel
if onlyA
    % max(A,[],dim,__)
    if omitnan
        m1 = max(a.v1,[],dim);
        i1 = a.v1 == m1;
        A2 = -Inf(size(i1));
        A2(i1) = a.v2(i1);
        m2 = max(A2,[],dim);
        i2 = A2 == m2;
    else
        m1 = max(a.v1,[],dim,"includenan");
        inan = isnan(a.v1);
        i1 = a.v1 == m1 | inan;
        A2 = -Inf(i1);
        A2(i1) = a.v2(i1);
        m2 = max(A2,[],dim,"includenan");
        i2 = A2 == m2 | inan;
    end
    itmp = i1 & i2;
    [~,i] = max(itmp,[],dim,'linear');
    
    if compareabs
        m1 = tmpA.v1(i);
        m2 = tmpA.v2(i);
    else
        m1 = a.v1(i);
        m2 = a.v2(i);
    end

    if ~linear
        h = size(itmp,1);
        if isnumeric(dim)
            if dim == 1
                i = mod(i,h);
                i(i==0) = h;
            elseif dim == 2
                i = ceil(i./h);
            end
        end
    end

else
    % max(A,B,__)
    c1 = a.v1 > b.v1;
    c2 = a.v1 == b.v1;
    c2(c2) = c2(c2) & (a.v2(c2) >= b.v2(c2));
    i = c1 | c2;
    if compareabs
        m1 = i.*tmpA.v1 + (~i).*tmpB.v1;
        m2 = i.*tmpA.v2 + (~i).*tmpB.v2;
    else
        m1 = i.*a.v1 + (~i).*b.v1;
        m2 = i.*a.v2 + (~i).*b.v2;
    end

    if ~omitnan
        % return NaN if nan is included
        c1 = isnan(a);
        c2 = isnan(b);
        i = c1 | c2;
        m1(i) = nan;
        m2(i) = nan;
    end
end

m = dd(m1,m2,'no');

end

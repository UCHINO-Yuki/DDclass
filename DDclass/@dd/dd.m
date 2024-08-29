classdef (InferiorClasses = {?mp,?sym}) dd ...
        < matlab.mixin.indexing.RedefinesParen ...
        & matlab.mixin.indexing.RedefinesDot ...
        & matlab.mixin.CustomDisplay
    % DD  class definition of double-double (DD) numbers
    %   
    %   The following special functions are provided:
    %
    %       * DD()          creates DD numbers, matries, and n-dim arrays.
    %                       Execute "help dd.dd" command to see the help text.
    %
    %       * DD.numSplit() sets the accurary of matrix multiplications.
    %                       Execute "help dd.numSplit" command to see the help text.
    %
    %       * DD.Info       returns the infomation (version etc.) about DDclass.
    %
    %       * startDD       sets the DDclass path and (re-)compiles mexcuda.
    %
    %       * ver('DDclass') returns version infomation.
    %
    %   High and low order parts of a DD number D can be references 
    %   by using dotReference:
    %
    %       * D1 = D.v1 returns high order part of D
    %       * D2 = D.v2 returns low order part of D
    %
    %   double() also returns high and low order parts of a DD number D:
    %
    %       * D1 = double(D)      returns high order part of D
    %       * [D1,D2] = double(D) returns high and low order parts of D.
    %
    %   Operations and functions for DD arrays can be used 
    %   in the same manner as for double arrays.
    %
    %   Many of the MATLAB built-in functions implemented in MATLAB code, 
    %   such as hadamard, wilkinson, linspace, anynan, allfinite, etc.,
    %   can be overloaded without modification. 
    %
    %   Floating-point numerical constants, such as 
    %       eps, 
    %       flintmax, 
    %       pi,
    %       realmax,
    %       realmin,
    %   can be used as
    %       DD.eps      or eps('DD'),
    %       DD.flintmax or flintmax('DD'),
    %       DD.pi,
    %       DD.realmax  or realmax('DD'),
    %       DD.realmin  or realmin('DD').
    %
    %   Floating-point arrays functions built in MATLAB, such as
    %       empty,
    %       eye,
    %       inf,
    %       nan,
    %       ones,
    %       rand,
    %       randi,
    %       randn,
    %       zeros,
    %   also can be used as
    %       DD.empty(...) or empty(...,'DD'),
    %       DD.eye(...)   or eye(...,'DD'),
    %       DD.inf(...)   or inf(...,'DD'),
    %       DD.nan(...)   or nan(...,'DD'),
    %       DD.ones(...)  or ones(...,'DD'),
    %       DD.rand(...)  or rand(...,'DD'),
    %       DD.randi(...) or randi(...,'DD'),
    %       DD.randn(...) or randn(...,'DD'),
    %       DD.zeros(...) or zeros(...,'DD').
    %
    %   See also DD.NUMSPLIT, DD.DD, DD.INFO, STARTDD, DD.DOUBLE
    %
    %   written ... 2024-02-25 ... UCHINO Yuki
    %   revised ... 2024-03-04 ... UCHINO Yuki
    %   revised ... 2024-03-05 ... UCHINO Yuki
    %   revised ... 2024-03-06 ... UCHINO Yuki
    %   revised ... 2024-03-17 ... UCHINO Yuki
    %   revised ... 2024-03-21 ... UCHINO Yuki
    %   revised ... 2024-03-28 ... UCHINO Yuki
    %   revised ... 2024-06-22 ... UCHINO Yuki
    %   revised ... 2024-08-29 ... UCHINO Yuki

    %% Values of double-double
    properties (GetAccess = public, SetAccess = private)
        v1 double {mustBeReal}  % high order part
        v2 double {mustBeReal}  % low order part
    end

    %% Private constants
    properties (Constant, Access = protected, Hidden = true)
        ddpi            = dd(3.1415926535897931e+00,1.2246467991473532e-16,"no");       % pi
        ddpiby2         = dd(1.5707963267948966e+00,6.1232339957367660e-17,"no");       % pi/2
        ddpiby4         = dd(7.8539816339744828e-01,3.0616169978683830e-17,"no");       % pi/4
        dd3piby4        = dd(2.3561944901923448e+00,9.1848509936051484e-17,"no");       % 3*pi/4
        ddpiby180       = dd(1.7453292519943295e-02,2.9486522708701687e-19,"no");       % pi/180
        dd180bypi       = dd(5.7295779513082323e+01,-1.9878495670576283e-15,"no");      % 180/pi
        ddpiby184320    = dd(1.7044230976507124e-05,2.8795432332716491e-22,"no");       % pi/180/1024
        dd2bysqrtpi     = dd(1.1283791670955126e+00,1.5335459613165881e-17,"no");       % 2/sqrt(pi)
        ddsqrt2bypi     = dd(7.9788456080286541e-01,-4.9846544045554601e-17,"no");      % sqrt(2/pi)
        dd1024bypi      = dd(3.2594932345220167e+02,-2.0150964915386866e-14,"no");      % 1024/pi
        ddflintmax      = dd(8.1129638414606682e+31,0,"no");                            % 2^106
        ddrealmax       = dd(1.7976931348623157e+308,1.9958403095347196e+292,"no");     % 2^1024*(1-2^-106)
        ddrealmin       = dd(realmin,0,"no");                                           % 2^-1074
        ddeps           = dd(4.93038065763132e-32,0,"no");                              % 2^-104
        ddsqrt2         = dd(1.4142135623730951e+00,-9.6672933134529135e-17,"no");      % sqrt(2)
        dde             = dd(2.7182818284590451e+00,1.4456468917292502e-16,"no");       % exp(1)
        ddexpm1         = dd(1.7182818284590453e+00,-7.7479915752106292e-17,"no");      % expm1(1)
        ddlog2          = dd(6.9314718055994529e-01,2.3190468138462996e-17,"no");       % log(2)
        ddlog10         = dd(2.3025850929940459e+00,-2.1707562233822494e-16,"no");      % log(10)
        cos_tab         = costable;                                                     % table of cos(0:pi/1024:pi/2)
        sin_tab         = sintable;                                                     % table of sin(0:pi/1024:pi/2)
        atan_tab        = atantable;                                                    % table of atan((16:1024)/1024)
        sinfact_tab     = sinfacttable;                                                 % table of (-1)^n/(2*n+1)! for n>=1
        cosfact_tab     = cosfacttable;                                                 % table of (-1)^n/(2*n)! for n>=2
        atanfact_tab    = atanfacttable;                                                % table of (-1)^n/(2*n+1) for n>=1
        asinhfact_tab   = asinhfacttable;                                               % table of (-1)^n*(2*n)!/2^(2*n)/(n!^2)/(2*n+1) for n>=1
        exp_tab         = exptable;                                                     % table of 2^(n/1024) for n=0:1023
        log_tab         = logtable;                                                     % table of log(1+n/1024) for n=0:1024
        expfact_tab     = expfacttable;                                                 % table of 1/n! for n>=3
        logfact_tab     = logfacttable;                                                 % table of 1/(2n+1)/(2^(2n)) for n>=1
        erffact_tab     = erffacttable;                                                 % table of 2^n/(2*n+1)!! for n>=1
        piby1024_tab    = piby1024table;                                                % table of pi/1024
        invpi_bits      = invpi_1213bits;                                               % 1213 bits of 2/pi * 2^1213
    end

    %% Static mathods
    methods (Static, Access = public)
        Info
        out = numSplit(k)
        out = rand(varargin)
        out = randn(varargin)
        out = randi(varargin)
        out = eye(varargin)
        out = ones(varargin)
        out = zeros(varargin)
        out = empty(varargin)
        out = inf(varargin)
        out = nan(varargin)
        out = realmax
        out = realmin
        out = flintmax
        out = eps
        out = pi
    end

    %% functions
    methods (Access = public)
        function c = dd(a,b,alg)
            % DD  Create double-double (DD) number, matrix, n-dim array.
            %       
            %   C = DD(A)           creates DD entity by conversion from A.
            %
            %   C = DD(A,B)         creates DD entity by the sum of A and B
            %                       using TwoSum proposed by Knuth.
            %
            %   C = DD(A,B,'fast')  creates DD entity by the sum of A and B
            %                       using FastTwoSum proposed by Dekker.
            %                       This creation method requires 
            %                           any(mod(A,pow2(B,-52))==0,'all') = 0.
            %
            %   C = DD(A,B,'no')    creates DD entity by A and B, where 
            %                       A and B is high and low order parts.
            %                       This creation method requires 
            %                           all(abs(B)<=0.5*ulp(A),'all') = 1,
            %                       where ulp(A) means Unit in the Last Place of A.
            %
            %   The input arguments must be the followings:
            %       * real integer entities,
            %       * real floating-point entities,
            %       * logical entities,
            %       * real symbolic entities.
            %       
            %   Sparse and gpuArray are supported as well.
            %
            %   See also DD
            %
            %   written ... 2024-02-25 ... UCHINO Yuki
            %   revised ... 2024-03-05 ... UCHINO Yuki
            
            arguments (Input)
                a {mustBeReal} = []
                b {mustBeReal} = []
                alg string {mustBeText} = "default"
            end

            if ~isnumeric(a) && ~isa(a,'sym') && ~islogical(a)
                error('Invalid input for dd.');
            end

            if nargin == 1
                if isUnderlyingType(a,'dd')
                    c = a;
                elseif isa(a,'mp') || isa(a,'sym')
                    c.v1 = double(a);
                    c.v2 = double(a-c.v1);
                elseif isUnderlyingType(a,'int64')
                    c.v1 = double(a);
                    c.v2 = double(a - int64(c.v1));
                elseif isUnderlyingType(a,'uint64')
                    c.v1 = double(a);
                    c.v2 = double(a - uint64(c.v1));
                else
                    c.v1 = double(a);
                    c.v2 = c.v1 .* isinf(c.v1);
                end
                return;
            end

            if ~isnumeric(b) && ~isa(b,'sym') && ~islogical(b)
                error('Invalid input for dd.');
            end

            if strcmp(alg,"no")
                [flag,c.v1,c.v2] = sizeCheck(double(a),double(b));
                if flag
                    error('Arrays have incompatible sizes for dd.');
                end
            elseif strcmp(alg,"fast")
                % [c.v1,c.v2] = FastTwoSum(double(a),double(b));
                da = double(a);
                db = double(b);
                try
                    c.v1 = da + db;
                catch
                    error('Arrays have incompatible sizes for dd.');
                end
                c.v2 = (da-c.v1) + db;
                idx = isinf(c.v1);
                c.v2(idx) = c.v1(idx);
            else
                % [c.v1,c.v2] = TwoSum(double(a),double(b));
                da = double(a);
                db = double(b);
                try
                    c.v1 = da + db;
                catch
                    error('Arrays have incompatible sizes for dd.');
                end
                z = c.v1-da;
                c.v2 = (da-(c.v1-z))+(db-z);
                idx = isinf(c.v1);
                c.v2(idx) = c.v1(idx);
            end
        end

        %% Resize, Reshape, Rearrange, Create, and Combine Arrays
        a = abs(a)
        s = sign(a)
        c = diag(a,k)
        c = blkdiag(a)
        a = tril(a,k)
        a = triu(a,k)
        c = transpose(a)
        c = ctranspose(a)
        a = conj(a)
        c = reshape(a,sz)
        c = repmat(a,r)
        c = repelem(a,r)
        c = cat(dim,a)
        c = horzcat(a)
        c = vertcat(a)

        %% Indexing and size
        c = colon(a,m,b)
        c = end(a,k,n)
        n = ndims(a)
        n = nnz(a)
        n = numel(a)
        n = length(a)
        varargout = size(a,dim)

        %% Cast
        [c1,c2] = double(a)
        c = single(a)
        c = int8(a)
        c = int16(a)
        c = int32(a)
        c = int64(a)
        c = uint8(a)
        c = uint16(a)
        c = uint32(a)
        c = uint64(a)
        c = sym(a,flag)
        c = vpa(a,d)
        c = mp(a,digits)
        varargout = gather(a)
        c = gpuArray(a)
        c = sparse(in1,in2,in3,in4,in5,in6)
        c = full(a)

        %% Logical
        c = and(a,b)
        c = or(a,b)
        c = not(a)
        c = eq(a,b)
        c = ne(a,b)
        c = ge(a,b)
        c = gt(a,b)
        c = le(a,b)
        c = lt(a,b)
        c = isbanded(A,lower,upper)
        c = isempty(a)
        c = isinf(a)
        c = isnan(a)
        c = ismissing(a,b)
        c = isfinite(a)
        c = isnumeric(a)
        c = isfloat(a)
        c = isreal(a)
        c = issparse(A)
        c = islogical(a)
        c = isscalar(a)
        c = isrow(a)
        c = iscolumn(a)
        c = isvector(a)
        c = ismatrix(a)
        c = isdiag(a)
        c = issymmetric(a,skewOption)
        c = ishermitian(a,skewOption)
        c = isUnderlyingType(a,typename)
        c = isa(a,typename)

        %% Rounding
        c = ceil(a)
        c = floor(a)
        c = fix(a)
        c = round(a,varargin)

        %% Basic operations
        c = plus(a,b)
        a = uplus(a)
        c = minus(a,b)
        a = uminus(a)
        c = times(a,b)
        c = ldivide(a,b)
        c = rdivide(a,b)
        a = sqrt(a)
        a = realsqrt(a)

        %% Elementary function
        a = pow2(a,p)
        a = power(a,p)
        a = realpow(a,p)
        c = nthroot(a,p)
        a = exp(a)
        a = expm1(a)
        a = log(a)
        a = reallog(a)
        a = log1p(a)
        [m,e] = log2(a)
        a = log10(a)
        a = erf(a)

        a = sin(a)
        a = sind(a)
        a = sinpi(a)
        a = asin(a)
        a = asind(a)
        a = sinh(a)
        a = asinh(a)

        a = cos(a)
        a = cosd(a)
        a = cospi(a)
        a = acos(a)
        a = acosd(a)
        a = cosh(a)
        a = acosh(a)

        a = tan(a)
        a = tand(a)
        a = atan(a,b)
        a = atand(a)
        c = atan2(a,b)
        c = atan2d(a,b)
        a = tanh(a)
        a = atanh(a)

        a = csc(a)
        a = cscd(a)
        a = acsc(a)
        a = acscd(a)
        a = csch(a)
        a = acsch(a)

        a = sec(a)
        a = secd(a)
        a = asec(a)
        a = asecd(a)
        a = sech(a)
        a = asech(a)

        a = cot(a)
        a = cotd(a)
        a = acot(a)
        a = acotd(a)
        a = coth(a)
        a = acoth(a)

        c = hypot(a,b)
        a = deg2rad(a)
        a = rad2deg(a)

        %% numerical linear algebra
        [m,i] = max(a,b,opt1,opt2,opt3,opt4,opt5)
        [m,i] = min(a,b,opt1,opt2,opt3,opt4,opt5)
        c = sum(a,dim,nanflag)
        c = mtimes(a,b)
        c = mldivide(a,b)
        c = mrdivide(b,a)
        c = mpower(a,b)
        c = inv(a)
        N = norm(a,p)
        N = vecnorm(a,p,dim)
        [N,cnt] = normest(a,tol)
        [out1,out2,out3] = eig(a,in2,in3)
        [out1,out2,out3] = svd(a,in2,in3)
        varargout = qr(a,in2)
    end

    %% private methods for indexing & display
    methods (Access = protected)
        a = parenAssign(a,indexOp,b)                % a(_) = b
        a = parenDelete(a,indexOp)                  % a(_) = []
        c = parenReference(a,indexOp)               % c = a(_)
        n = parenListLength(a,indexOp,indexContext) % #outputs for parenReference
        a = dotAssign(a,indexOp,varargin)           % a._ = varargin{:} (Not supported)
        varargout = dotReference(a,indexOp)         % c = a._
        n = dotListLength(a,indexOp,indexContext)   % #outputs for braceReference
        out = getHeader(obj)                        % display header
        out = getFooter(obj)                        % display footer
        out = getPropertyGroups(~)                  % display properties
    end

end

function c = sum(a,dim,nanflag)
% SUM   Sum of array elements.
%
%   See also SUM
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    dim = 1
    nanflag string {mustBeMember(nanflag,["includemissing","includenan","omitmissing","omitnan"])} = "includemissing"
end

if isnumeric(dim)
    mustBeInteger(dim);
else
    mustBeMember(dim,'all');
end

if size(a.v1,1) == 1
    dim = 2;
end

if ismember(nanflag,["omitmissing","omitnan"])
    idx = isnan(a);
    a.v1(idx) = 0;
    a.v2(idx) = 0;
end

if isempty(a)
    c = dd(sum(a.v1,dim,nanflag));
    return;
end

a1=a.v1;
a2=a.v2;
if strcmp(dim,"all")
    n = numel(a1);
else
    n = size(a1,dim);
end
q = nextpow2(n);

[x2,x1] = bounds(a1,dim);
mu = max(x1,-x2);
t = pow2(0.75,q+nextpow2(mu));
T = (a1+t)-t;
a1 = a1-T;
c1 = sum(T,dim);
[a1,a2] = FastTwoSum(a1,a2);

[x2,x1] = bounds(a1,dim);
mu = max(x1,-x2);
t = pow2(0.75,q+nextpow2(mu));
T = (a1+t)-t;
a1 = a1-T;
c2 = sum(T,dim);
c3 = sum(a1+a2,dim);

[c1,c2] = FastTwoSum(c1,c2);
[c1,c3] = FastTwoSum(c1,c3);
c2 = c2 + c3;
[c1,c2] = FastTwoSum(c1,c2);

% Cast to dd
c = dd(c1,c2,"no");
end

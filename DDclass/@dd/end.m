function c = end(a,k,n)
% END   Terminate block of code or indicate last array index
%
%   See also END
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    k double
    n double
end

sz = size(a.v1);
if k<n
    c = sz(k);
else
    c = prod(sz(k:end));
end
end


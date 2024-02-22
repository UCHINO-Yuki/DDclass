function a = log10(a)
% LOG10  Common logarithm (base 10)
%
%   See also LOG10
%
%   written ... 2024-02-23 ... UCHINO Yuki

if isempty(a)
    return;
end
a = log(a)./dd.ddlog10;
end
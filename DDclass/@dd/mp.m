function c = mp(a,digits)
% MP  Create multiprecision floating-point array of required precision.
%
%   See also <a href="matlab: web('https://www.advanpix.com')">ADVANPIX</a>
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    digits (1,1) double = 34
end

if nargin == 1
    c = mp(gather(a.v1))+mp(gather(a.v2));
else
    c = mp(gather(a.v1),digits)+mp(gather(a.v2),digits);
end
end
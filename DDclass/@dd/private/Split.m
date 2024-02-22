function [ah,al] = Split(a)
% SPLIT     Error-free split ah+al := a
%
%   written ... 2024-02-23 ... UCHINO Yuki

al = 134217729.*a;   % 134217729 = 1 + 2^27
ah = al-(al-a);
al = a-ah;
end
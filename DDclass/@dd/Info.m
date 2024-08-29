function Info
% INFO  Dispaly information about DDclass.
%
%   See also DD
%
%   written ... 2024-02-25 ... UCHINO Yuki
%   revised ... 2024-03-05 ... UCHINO Yuki
%   revised ... 2024-03-06 ... UCHINO Yuki
%   revised ... 2024-03-08 ... UCHINO Yuki
%   revised ... 2024-03-17 ... UCHINO Yuki
%   revised ... 2024-03-18 ... UCHINO Yuki
%   revised ... 2024-03-21 ... UCHINO Yuki
%   revised ... 2024-03-22 ... UCHINO Yuki
%   revised ... 2024-03-24 ... UCHINO Yuki
%   revised ... 2024-03-27 ... UCHINO Yuki
%   revised ... 2024-03-28 ... UCHINO Yuki
%   revised ... 2024-03-30 ... UCHINO Yuki
%   revised ... 2024-06-16 ... UCHINO Yuki
%   revised ... 2024-06-22 ... UCHINO Yuki
%   revised ... 2024-06-23 ... UCHINO Yuki
%   revised ... 2024-07-25 ... UCHINO Yuki
%   revised ... 2024-08-09 ... UCHINO Yuki
%   revised ... 2024-08-29 ... UCHINO Yuki

v = ver('DDclass');
fprintf('\n----------------------------------------------------\n');
fprintf(' DDclass - %s\n',v.Name);
fprintf(' Version : %s\n',v.Version);
fprintf(' Date    : %s\n',v.Date);
fprintf(' (c) %s UCHINO Yuki\n',v.Date(end-3:end));
fprintf('----------------------------------------------------\n\n');
end
function t = cosfacttable
% COSFACTTABLE
%
%   t = (-1).^n./factorial(2.*n) for n=2:4
%
%   written ... 2024-02-23 ... UCHINO Yuki
t = dd([
    4.1666666666666664e-02
    -1.3888888888888889e-03
    2.4801587301587302e-05
    ],[
    2.3129646346357427e-18
    5.3005439543735771e-20
    2.1511947866775882e-23
    ],"no");
end
% A double-double class toolbox for MATLAB
% Version 1.11.0 29-Aug-2024
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

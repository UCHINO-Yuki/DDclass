function c = isbanded(a,lower,upper)
% ISBANDED   Determine if matrix is within specified bandwidth.
%
%   See also ISBANDED
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    lower (1,1) double {mustBeInteger}
    upper (1,1) double {mustBeInteger}
end
c = isbanded(a.v1,lower,upper);
end
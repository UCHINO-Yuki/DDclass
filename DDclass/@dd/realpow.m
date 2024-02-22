function c = realpow(a,p)
% REALPOW    Array power for real-only output.
%
%   See also REALPOW
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input)
    a dd
    p double {mustBeReal}
end

idx = (a.v1 < 0) & (p ~= round(p));
if any(idx,'all')
    error('realpow produced complex result.');
end
c = power(a,p);

end
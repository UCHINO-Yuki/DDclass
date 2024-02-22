function c = vertcat(a)
% VERTCAT   Concatenate arrays vertically.
%
%   See also VERTCAT
%
%   written ... 2024-02-23 ... UCHINO Yuki

arguments (Input, Repeating)
    a dd
end

n = numel(a);
b1{n} = a{n}.v1;
b2{n} = a{n}.v2;
for i=1:n-1
    b1{i} = a{i}.v1;
    b2{i} = a{i}.v2;
end
c = dd(vertcat(b1{:}),vertcat(b2{:}),"no");
end
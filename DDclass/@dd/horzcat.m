function c = horzcat(a)
% HORZCAT   Concatenate arrays horizontally.
%
%   See also HORZCAT
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
c = dd(horzcat(b1{:}),horzcat(b2{:}),"no");
end
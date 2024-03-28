function b = reduction(a,trig)
% REDUCTION   range reduction for trigonometric functions
%
%   written ... 2024-03-27 ... UCHINO Yuki
%   revised ... 2024-03-28 ... UCHINO Yuki

% a =: N * 2^M with odd integer N
% a =: x1 + x2 + x3
ufpa = floor(log2(abs(a)));     % ufp(abs(a))
M = 53-ufpa;                    % exponent of shift value 2^M
b = pow2(a,M);                  % shift a.v1
i64 = int64(abs(b));            % convert into uint64
x = cell(1,3);
x{1} = double(single(b));       % first 24 bits of a.v1
b = b - x{1};
x{2} = double(single(b));       % second 24 bits of a.v1
x{3} = b - x{2};                % remainder bits of a.v1
i64 = bitand(i64,-i64);         % least significant bit
P = nextpow2(double(i64));
M = P - M;                      % N * 2^M := a.v1 with odd integer N
for j=1:3
    x{j} = pow2(x{j},-22-P);
end

% 2/pi
tmp = repmat(dd.invpi_bits,size(M));
invpi = cell(1,8);
j=1;
P = M;
while true
    tmp1 = extractBefore(extractAfter(tmp,P-2),25);
    invpi{j} = pow2(bin2dec(tmp1),-24*(j-1));
    j=j+1;
    if j>8
        break;
    end
    P = P+24;
end

% x * invpi
lx = length(x);
li = length(invpi);
ly = lx+li-1;
y = cell(1,ly);
for j=2:ly+1
    for k=1:lx
        for l=1:li
            if j==k+l
                tmp = x{k}.*invpi{l};
                if isempty(y{j-1})
                    y{j-1} = tmp;
                else
                    y{j-1} = y{j-1} + tmp;
                end
            end
        end
    end
end

for j=1:ly
    y{j} = dd(y{j}) - pow2(floor(pow2(y{j},-2)),2);
end
y1 = y{ly};
for j=ly-1:-1:1
    y1 = y1 + y{j};
end
y2 = y{1} - y1;
for j=2:ly
    y2 = y2 + y{j};
end
y3 = round(y1);
b = (y1 - y3) + y2;
b = b .* dd.pi./2;
x{1} = y3.v1 - pow2(floor(pow2(y3.v1,-2)),2);

switch trig
    case 'sin'
        b(x{1} == 1) = b(x{1} == 1) + dd.pi./2;
        b(x{1} == 2) = -b(x{1} == 2);
        b(x{1} == 3) = b(x{1} == 3) - dd.pi./2;
        % b = sin(b);
    case 'cos'
        b(x{1} == 1) = b(x{1} == 1) + dd.pi./2;
        b(x{1} == 2) = b(x{1} == 2) + dd.pi;
        b(x{1} == 3) = b(x{1} == 3) - dd.pi./2;
        % b = cos(b);
    case 'tan'
        idx = x{1} == 1 | x{1} == 3;
        b(idx) = b(idx) - dd.pi./2;
        % b = tan(b);
end

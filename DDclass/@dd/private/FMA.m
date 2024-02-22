function d = FMA(a,b,c)
% FMA  fused multiply-add
%
%   See also fma
%
%   written ... 2024-02-23 ... UCHINO Yuki

if isgpuarray(a) || isgpuarray(b) || isgpuarray(c)
    sizeA = size(a);
    sizeB = size(B);
    sizeC = size(C);
    sizeD = max(max(sizeA,sizeB),sizeC);
    if any(sizeD>sizeA)
        a = repmat(a,sizeD./sizeA);
    end
    if any(sizeD>sizeB)
        b = repmat(b,sizeD./sizeB);
    end
    if any(sizeD>sizeC)
        c = repmat(c,sizeD./sizeC);
    end
    d = gpu_fma(a,b,c);
else
    d = fma(a,b,c);
end
end
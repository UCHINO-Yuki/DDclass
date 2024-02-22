function p = CompileMEXCUDA
% COMPILEMEXCUDA   compile mexcuda
%
%   See also DD, INFO, STARTDD
%
%   written ... 2024-02-23 ... UCHINO Yuki
s = warning;
warning('off')
p = true;
try
    mexcuda @DD/private/gpu_fma.cu ...
        -R2018a -lcuda -silent ...
        -outdir @DD/private
catch
    p = false;
end
warning(s)
end
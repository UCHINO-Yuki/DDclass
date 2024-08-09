# DDclass - A double-double class toolbox for MATLAB

The dd (double-double) class provides approximately quadruple precision computation.

Operations and functions for dd class can be used in the same manner as for double class.

Sparse matrices and gpuArray are supported as well.

The following functions and operations are implemented using mixed-precision algorithms:
- `eig`
- `inv`
- `mldivide` (`\`)
- `mrdivide` (`/`)
- `mtimes` (`*`)
- `sum`
- `svd`

## System requirements

MATLAB R2022a or later is required.

"Fixed-Point Designer" toolbox is required (for `fma`).

[Option] To use gpuArray, "Parallel Computing Toolbox" toolbox is required.

[Option] To use gpuArray, [the NVIDIA CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit) is required to compile `*.cuda` files.

## Installation

1. Change the current folder to "DDclass".
2. Execute the following command to add the toolbox path to MATLAB's search path and compile the cu file.
```
startDD;
```
If cuda compiler failed, try the following command and then recompile.
```
setenv("NVCC_APPEND_FLAGS", '-allow-unsupported-compiler');
```
3. You can also permanently save the search path by using the `pathtool` command and clicking "save".

## Usage

Execude the following command to display the documentation:
```
doc dd;
```
The expressions and the constants of dd class are evaluated when loading the class. 
Therefore, it takes a little time when dd class is first called.

## Example
```
%% dd array creation
a = randn(2); b = randn(2);
c = dd(a)                           % Create dd array as c1 = a, c2 = 0;.
c = dd(a,b)                         % Create dd array as [c1,c2] = TwoSum(a,b);.
c = dd(a,b,'fast')                  % Create dd array as [c1,c2] = FastTwoSum(a,b);. 
                                    % For this method, any(mod(A,pow2(B,-52))==0,'all') must be 0.
c = dd(a,b,'no')                    % Create dd array as c1 = a, c2 = b;.
                                    % For this method, all(abs(B)<=0.5*ulp(A),'all') must be 1.
c = randn(2,'dd')                   % Create dd array of normally distributed random numbers.
                                    % The other arrays functions built in MATLAB also can be used.

%% matrix multiplications
a = randn(10,'dd'); b = randn(10,'dd');
sc = sym(a,'f')*sym(b,'f');         % exact a*b.
dd.numSplit(1);                     % Set the accuracy (the number of split matrices for Ozaki's scheme).
                                    % if dd.numSplit = 1, it's just double precision matrix multiplications.
                                    % The default is 5.
c = a*b;                            % Compute a*b in double.
max(double((c-sc)./sc),[],'all')    % Relative error.

dd.numSplit(2);                     % Set the accuracy.
c = a*b;                            % Compute a*b in dd by using Ozaki's scheme.
max(double((c-sc)./sc),[],'all')    % Relative error.

dd.numSplit(3);                     % Set the accuracy.
c = a*b;                            % Compute a*b in dd by using Ozaki's scheme.
max(double((c-sc)./sc),[],'all')    % Relative error.

dd.numSplit(4);                     % Set the accuracy.
c = a*b;                            % Compute a*b in dd by using Ozaki's scheme.
max(double((c-sc)./sc),[],'all')    % Relative error.
```

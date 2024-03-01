# DDclass - A double-double class toolbox for MATLAB

The dd (double-double) class provides approximately quadruple precision computation.

Operations and functions for dd class can be used in the same manner as for double class.

Sparse matrices and gpuArray are supported as well.

The following functions and operations are implemented using mixed-precision algorithms:
- `eig`
- `mldivide` (`\`)
- `mrdivide` (`/`)
- `mtimes` (`*`)
- `sum`
- `svd`

## System requirements

MATLAB R2021b or later is required.

## Installation

1. Change the current folder to "DDclass".
2. Execute the following command to add the toolbox path to MATLAB's search path and compile the cu file.
```
startDD;
```
3. You can also permanently save the search path by using the `pathtool` command and clicking "save".

## Usage

Execude the following command to display the documentation:
```
doc dd;
```

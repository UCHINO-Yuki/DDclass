/**
 * @file gpu_fma.cu
 * @author UCHINO Yuki
 * @brief This function computes D = fma(A,B,C).
 * @version 1.0
 * @date 2024-02-23
 * @copyright Copyright (c) 2024 UCHINO Yuki
**/

#include "mex.h"
#include "gpu/mxGPUArray.h"
#include <cuda.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

void __global__ gpuFMA(double const * const A,
        double const * const B,
        double const * const C,
        double * const D,
        int const N){
	const int i = blockDim.x * blockIdx.x + threadIdx.x;
	if(i < N){
        D[i] = fma(A[i],B[i],C[i]);
    }
}

// D = fma(A,B,C)
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, mxArray const *prhs[])
{
    /* Declare all variables.*/
    mxGPUArray const *A;
    mxGPUArray const *B;
    mxGPUArray const *C;
    mxGPUArray *D;

    /* Choose a reasonably sized number of threads for the block. */
    int const threadsPerBlock = 1024;
    int blocksPerGrid;

    /* Initialize the MathWorks GPU API. */
    mxInitGPU();

    A = mxGPUCreateFromMxArray(prhs[0]);
    B = mxGPUCreateFromMxArray(prhs[1]);
    C = mxGPUCreateFromMxArray(prhs[2]);

    int N;
    double const *d_A;
    double const *d_B;
    double const *d_C;
    double *d_D;

    /*
    * Now that we have verified the data type, extract a pointer to the input
    * data on the device.
    */
    d_A = (double const *)(mxGPUGetDataReadOnly(A));
    d_B = (double const *)(mxGPUGetDataReadOnly(B));
    d_C = (double const *)(mxGPUGetDataReadOnly(C));

    /* Create a GPUArray to hold the result and get its underlying pointer. */
    D = mxGPUCreateGPUArray(mxGPUGetNumberOfDimensions(A),
                            mxGPUGetDimensions(A),
                            mxGPUGetClassID(A),
                            mxGPUGetComplexity(A),
                            MX_GPU_DO_NOT_INITIALIZE);
    d_D = (double *)(mxGPUGetData(D));

    /*
    * Call the kernel using the CUDA runtime API. We are using a 1-d grid here,
    * and it would be possible for the number of elements to be too large for
    * the grid. For this example we are not guarding against this possibility.
    */
    N = (int)(mxGPUGetNumberOfElements(A));
    blocksPerGrid = (N + 1023) >> 10;
    gpuFMA<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, d_D, N);

    /* Wrap the result up as a MATLAB gpuArray for return. */
    plhs[0] = mxGPUCreateMxArrayOnGPU(D);

    /*
     * The mxGPUArray pointers are host-side structures that refer to device
     * data. These must be destroyed before leaving the MEX function.
     */
    mxGPUDestroyGPUArray(A);
    mxGPUDestroyGPUArray(B);
    mxGPUDestroyGPUArray(C);
    mxGPUDestroyGPUArray(D);
}
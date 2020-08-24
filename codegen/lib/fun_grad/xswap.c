/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xswap.c
 *
 * Code generation for function 'xswap'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "fun_grad.h"
#include "xswap.h"

/* Function Definitions */
void xswap(creal_T x[6400], int ix0, int iy0)
{
  int ix;
  int iy;
  int k;
  double temp_re;
  double temp_im;
  ix = ix0 - 1;
  iy = iy0 - 1;
  for (k = 0; k < 80; k++) {
    temp_re = x[ix].re;
    temp_im = x[ix].im;
    x[ix] = x[iy];
    x[iy].re = temp_re;
    x[iy].im = temp_im;
    ix += 80;
    iy += 80;
  }
}

/* End of code generation (xswap.c) */

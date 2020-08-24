/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mrdivide.c
 *
 * Code generation for function 'mrdivide'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "fun_grad.h"
#include "mrdivide.h"
#include "xtrsm.h"
#include "xgetrf.h"

/* Function Definitions */
void b_mrdivide(const creal_T A[80], const creal_T B[6400], creal_T y[80])
{
  creal_T b_A[6400];
  int ipiv[80];
  int info;
  double temp_re;
  double temp_im;
  memcpy(&b_A[0], &B[0], 6400U * sizeof(creal_T));
  xgetrf(b_A, ipiv, &info);
  memcpy(&y[0], &A[0], 80U * sizeof(creal_T));
  c_xtrsm(b_A, y);
  d_xtrsm(b_A, y);
  for (info = 78; info >= 0; info--) {
    if (ipiv[info] != info + 1) {
      temp_re = y[info].re;
      temp_im = y[info].im;
      y[info] = y[ipiv[info] - 1];
      y[ipiv[info] - 1].re = temp_re;
      y[ipiv[info] - 1].im = temp_im;
    }
  }
}

void mrdivide(const creal_T A[6400], const creal_T B[6400], creal_T y[6400])
{
  creal_T b_A[6400];
  int ipiv[80];
  int info;
  int jp;
  int xi;
  double temp_re;
  double temp_im;
  memcpy(&b_A[0], &B[0], 6400U * sizeof(creal_T));
  xgetrf(b_A, ipiv, &info);
  memcpy(&y[0], &A[0], 6400U * sizeof(creal_T));
  xtrsm(b_A, y);
  b_xtrsm(b_A, y);
  for (info = 78; info >= 0; info--) {
    if (ipiv[info] != info + 1) {
      jp = ipiv[info] - 1;
      for (xi = 0; xi < 80; xi++) {
        temp_re = y[xi + 80 * info].re;
        temp_im = y[xi + 80 * info].im;
        y[xi + 80 * info] = y[xi + 80 * jp];
        y[xi + 80 * jp].re = temp_re;
        y[xi + 80 * jp].im = temp_im;
      }
    }
  }
}

/* End of code generation (mrdivide.c) */

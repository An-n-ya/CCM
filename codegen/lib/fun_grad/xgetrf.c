/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgetrf.c
 *
 * Code generation for function 'xgetrf'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "fun_grad.h"
#include "xgetrf.h"
#include "xswap.h"

/* Function Definitions */
void xgetrf(creal_T A[6400], int ipiv[80], int *info)
{
  int i3;
  int j;
  int c;
  int jA;
  int ix;
  double smax;
  int jy;
  double brm;
  int b_j;
  double A_re;
  double A_im;
  double temp_im;
  double b_A_im;
  int ijA;
  for (i3 = 0; i3 < 80; i3++) {
    ipiv[i3] = 1 + i3;
  }

  *info = 0;
  for (j = 0; j < 79; j++) {
    c = j * 81;
    jA = 1;
    ix = c;
    smax = fabs(A[c].re) + fabs(A[c].im);
    for (jy = 2; jy <= 80 - j; jy++) {
      ix++;
      brm = fabs(A[ix].re) + fabs(A[ix].im);
      if (brm > smax) {
        jA = jy;
        smax = brm;
      }
    }

    if ((A[(c + jA) - 1].re != 0.0) || (A[(c + jA) - 1].im != 0.0)) {
      if (jA - 1 != 0) {
        ipiv[j] = j + jA;
        xswap(A, j + 1, j + jA);
      }

      i3 = (c - j) + 80;
      for (jA = c + 1; jA + 1 <= i3; jA++) {
        A_re = A[jA].re;
        A_im = A[jA].im;
        temp_im = A[c].re;
        b_A_im = A[c].im;
        if (b_A_im == 0.0) {
          if (A_im == 0.0) {
            A[jA].re = A_re / temp_im;
            A[jA].im = 0.0;
          } else if (A_re == 0.0) {
            A[jA].re = 0.0;
            A[jA].im = A_im / temp_im;
          } else {
            A[jA].re = A_re / temp_im;
            A[jA].im = A_im / temp_im;
          }
        } else if (temp_im == 0.0) {
          if (A_re == 0.0) {
            A[jA].re = A_im / b_A_im;
            A[jA].im = 0.0;
          } else if (A_im == 0.0) {
            A[jA].re = 0.0;
            A[jA].im = -(A_re / b_A_im);
          } else {
            A[jA].re = A_im / b_A_im;
            A[jA].im = -(A_re / b_A_im);
          }
        } else {
          brm = fabs(temp_im);
          smax = fabs(b_A_im);
          if (brm > smax) {
            brm = b_A_im / temp_im;
            smax = temp_im + brm * b_A_im;
            A[jA].re = (A_re + brm * A_im) / smax;
            A[jA].im = (A_im - brm * A_re) / smax;
          } else if (smax == brm) {
            if (temp_im > 0.0) {
              temp_im = 0.5;
            } else {
              temp_im = -0.5;
            }

            if (b_A_im > 0.0) {
              smax = 0.5;
            } else {
              smax = -0.5;
            }

            A[jA].re = (A_re * temp_im + A_im * smax) / brm;
            A[jA].im = (A_im * temp_im - A_re * smax) / brm;
          } else {
            brm = temp_im / b_A_im;
            smax = b_A_im + brm * temp_im;
            A[jA].re = (brm * A_re + A_im) / smax;
            A[jA].im = (brm * A_im - A_re) / smax;
          }
        }
      }
    } else {
      *info = j + 1;
    }

    jA = c;
    jy = c + 80;
    for (b_j = 1; b_j <= 79 - j; b_j++) {
      if ((A[jy].re != 0.0) || (A[jy].im != 0.0)) {
        smax = -A[jy].re - A[jy].im * 0.0;
        temp_im = A[jy].re * 0.0 + -A[jy].im;
        ix = c + 1;
        i3 = (jA - j) + 160;
        for (ijA = 81 + jA; ijA + 1 <= i3; ijA++) {
          A_im = A[ix].re * temp_im + A[ix].im * smax;
          A[ijA].re += A[ix].re * smax - A[ix].im * temp_im;
          A[ijA].im += A_im;
          ix++;
        }
      }

      jy += 80;
      jA += 80;
    }
  }

  if ((*info == 0) && (!((A[6399].re != 0.0) || (A[6399].im != 0.0)))) {
    *info = 80;
  }
}

/* End of code generation (xgetrf.c) */

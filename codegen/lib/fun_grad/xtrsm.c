/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xtrsm.c
 *
 * Code generation for function 'xtrsm'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "fun_grad.h"
#include "xtrsm.h"
#include "recip.h"

/* Function Definitions */
void b_xtrsm(const creal_T A[6400], creal_T B[6400])
{
  int j;
  int jBcol;
  int jAcol;
  int k;
  int kBcol;
  int i;
  double A_im;
  for (j = 79; j >= 0; j--) {
    jBcol = 80 * j;
    jAcol = 80 * j - 1;
    for (k = j + 2; k < 81; k++) {
      kBcol = 80 * (k - 1);
      if ((A[k + jAcol].re != 0.0) || (A[k + jAcol].im != 0.0)) {
        for (i = 0; i < 80; i++) {
          A_im = A[k + jAcol].re * B[i + kBcol].im + A[k + jAcol].im * B[i +
            kBcol].re;
          B[i + jBcol].re -= A[k + jAcol].re * B[i + kBcol].re - A[k + jAcol].im
            * B[i + kBcol].im;
          B[i + jBcol].im -= A_im;
        }
      }
    }
  }
}

void c_xtrsm(const creal_T A[6400], creal_T B[80])
{
  int j;
  int jAcol;
  int k;
  creal_T dc0;
  double B_re;
  double B_im;
  for (j = 0; j < 80; j++) {
    jAcol = 80 * j;
    for (k = 1; k <= j; k++) {
      if ((A[(k + jAcol) - 1].re != 0.0) || (A[(k + jAcol) - 1].im != 0.0)) {
        B_re = A[(k + jAcol) - 1].re * B[k - 1].im + A[(k + jAcol) - 1].im * B[k
          - 1].re;
        B[j].re -= A[(k + jAcol) - 1].re * B[k - 1].re - A[(k + jAcol) - 1].im *
          B[k - 1].im;
        B[j].im -= B_re;
      }
    }

    dc0 = recip(A[j + jAcol]);
    B_re = B[j].re;
    B_im = B[j].im;
    B[j].re = dc0.re * B_re - dc0.im * B_im;
    B[j].im = dc0.re * B_im + dc0.im * B_re;
  }
}

void d_xtrsm(const creal_T A[6400], creal_T B[80])
{
  int j;
  int jAcol;
  int k;
  double A_im;
  for (j = 79; j >= 0; j--) {
    jAcol = 80 * j - 1;
    for (k = j + 2; k < 81; k++) {
      if ((A[k + jAcol].re != 0.0) || (A[k + jAcol].im != 0.0)) {
        A_im = A[k + jAcol].re * B[k - 1].im + A[k + jAcol].im * B[k - 1].re;
        B[j].re -= A[k + jAcol].re * B[k - 1].re - A[k + jAcol].im * B[k - 1].im;
        B[j].im -= A_im;
      }
    }
  }
}

void xtrsm(const creal_T A[6400], creal_T B[6400])
{
  int j;
  int jBcol;
  int jAcol;
  int k;
  creal_T temp;
  int kBcol;
  int i;
  double B_re;
  double B_im;
  for (j = 0; j < 80; j++) {
    jBcol = 80 * j;
    jAcol = 80 * j;
    for (k = 1; k <= j; k++) {
      kBcol = 80 * (k - 1);
      if ((A[(k + jAcol) - 1].re != 0.0) || (A[(k + jAcol) - 1].im != 0.0)) {
        for (i = 0; i < 80; i++) {
          B_re = A[(k + jAcol) - 1].re * B[i + kBcol].im + A[(k + jAcol) - 1].im
            * B[i + kBcol].re;
          B[i + jBcol].re -= A[(k + jAcol) - 1].re * B[i + kBcol].re - A[(k +
            jAcol) - 1].im * B[i + kBcol].im;
          B[i + jBcol].im -= B_re;
        }
      }
    }

    temp = recip(A[j + jAcol]);
    for (i = 0; i < 80; i++) {
      B_re = B[i + jBcol].re;
      B_im = B[i + jBcol].im;
      B[i + jBcol].re = temp.re * B_re - temp.im * B_im;
      B[i + jBcol].im = temp.re * B_im + temp.im * B_re;
    }
  }
}

/* End of code generation (xtrsm.c) */

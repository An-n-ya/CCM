/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eye.c
 *
 * Code generation for function 'eye'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "fun_grad.h"
#include "eye.h"

/* Function Definitions */
void eye(double I[6400])
{
  int k;
  memset(&I[0], 0, 6400U * sizeof(double));
  for (k = 0; k < 80; k++) {
    I[k + 80 * k] = 1.0;
  }
}

/* End of code generation (eye.c) */

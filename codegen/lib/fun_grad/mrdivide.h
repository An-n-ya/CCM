/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mrdivide.h
 *
 * Code generation for function 'mrdivide'
 *
 */

#ifndef MRDIVIDE_H
#define MRDIVIDE_H

/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rtwtypes.h"
#include "fun_grad_types.h"

/* Function Declarations */
extern void b_mrdivide(const creal_T A[80], const creal_T B[6400], creal_T y[80]);
extern void mrdivide(const creal_T A[6400], const creal_T B[6400], creal_T y
                     [6400]);

#endif

/* End of code generation (mrdivide.h) */

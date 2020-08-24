/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xtrsm.h
 *
 * Code generation for function 'xtrsm'
 *
 */

#ifndef XTRSM_H
#define XTRSM_H

/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rtwtypes.h"
#include "fun_grad_types.h"

/* Function Declarations */
extern void b_xtrsm(const creal_T A[6400], creal_T B[6400]);
extern void c_xtrsm(const creal_T A[6400], creal_T B[80]);
extern void d_xtrsm(const creal_T A[6400], creal_T B[80]);
extern void xtrsm(const creal_T A[6400], creal_T B[6400]);

#endif

/* End of code generation (xtrsm.h) */

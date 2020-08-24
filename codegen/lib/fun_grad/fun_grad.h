/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fun_grad.h
 *
 * Code generation for function 'fun_grad'
 *
 */

#ifndef FUN_GRAD_H
#define FUN_GRAD_H

/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rtwtypes.h"
#include "fun_grad_types.h"

/* Function Declarations */
extern void fun_grad(const creal_T s[80], const creal_T A0[6400], const creal_T
                     phi_S[6400], const creal_T K, const creal_T q[3], const
                     creal_T Ak[19200], creal_T df[80]);

#endif

/* End of code generation (fun_grad.h) */

/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_fun_grad_api.h
 *
 * Code generation for function '_coder_fun_grad_api'
 *
 */

#ifndef _CODER_FUN_GRAD_API_H
#define _CODER_FUN_GRAD_API_H

/* Include files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_fun_grad_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void fun_grad(creal_T s[80], creal_T A0[6400], creal_T phi_S[6400],
                     creal_T K, creal_T q[3], creal_T Ak[19200], creal_T df[80]);
extern void fun_grad_api(const mxArray * const prhs[6], const mxArray *plhs[1]);
extern void fun_grad_atexit(void);
extern void fun_grad_initialize(void);
extern void fun_grad_terminate(void);
extern void fun_grad_xil_terminate(void);

#endif

/* End of code generation (_coder_fun_grad_api.h) */

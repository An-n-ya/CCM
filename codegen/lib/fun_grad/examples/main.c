/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include files */
#include "rt_nonfinite.h"
#include "fun_grad.h"
#include "main.h"
#include "fun_grad_terminate.h"
#include "fun_grad_initialize.h"

/* Function Declarations */
static void argInit_1x3_creal_T(creal_T result[3]);
static void argInit_80x1_creal_T(creal_T result[80]);
static void argInit_80x80_creal_T(creal_T result[6400]);
static void argInit_80x80x3_creal_T(creal_T result[19200]);
static creal_T argInit_creal_T(void);
static double argInit_real_T(void);
static void main_fun_grad(void);

/* Function Definitions */
static void argInit_1x3_creal_T(creal_T result[3])
{
  int idx1;

  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < 3; idx1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[idx1] = argInit_creal_T();
  }
}

static void argInit_80x1_creal_T(creal_T result[80])
{
  int idx0;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 80; idx0++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[idx0] = argInit_creal_T();
  }
}

static void argInit_80x80_creal_T(creal_T result[6400])
{
  int idx0;
  int idx1;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 80; idx0++) {
    for (idx1 = 0; idx1 < 80; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result[idx0 + 80 * idx1] = argInit_creal_T();
    }
  }
}

static void argInit_80x80x3_creal_T(creal_T result[19200])
{
  int idx0;
  int idx1;
  int idx2;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 80; idx0++) {
    for (idx1 = 0; idx1 < 80; idx1++) {
      for (idx2 = 0; idx2 < 3; idx2++) {
        /* Set the value of the array element.
           Change this value to the value that the application requires. */
        result[(idx0 + 80 * idx1) + 6400 * idx2] = argInit_creal_T();
      }
    }
  }
}

static creal_T argInit_creal_T(void)
{
  creal_T result;

  /* Set the value of the complex variable.
     Change this value to the value that the application requires. */
  result.re = argInit_real_T();
  result.im = argInit_real_T();
  return result;
}

static double argInit_real_T(void)
{
  return 0.0;
}

static void main_fun_grad(void)
{
  creal_T dcv0[80];
  static creal_T dcv1[6400];
  static creal_T dcv2[6400];
  creal_T dcv3[3];
  static creal_T dcv4[19200];
  creal_T df[80];

  /* Initialize function 'fun_grad' input arguments. */
  /* Initialize function input argument 's'. */
  /* Initialize function input argument 'A0'. */
  /* Initialize function input argument 'phi_S'. */
  /* Initialize function input argument 'K'. */
  /* Initialize function input argument 'q'. */
  /* Initialize function input argument 'Ak'. */
  /* Call the entry-point 'fun_grad'. */
  argInit_80x1_creal_T(dcv0);
  argInit_80x80_creal_T(dcv1);
  argInit_80x80_creal_T(dcv2);
  argInit_1x3_creal_T(dcv3);
  argInit_80x80x3_creal_T(dcv4);
  fun_grad(dcv0, dcv1, dcv2, argInit_creal_T(), dcv3, dcv4, df);
}

int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  fun_grad_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_fun_grad();

  /* Terminate the application.
     You do not need to do this more than one time. */
  fun_grad_terminate();
  return 0;
}

/* End of code generation (main.c) */

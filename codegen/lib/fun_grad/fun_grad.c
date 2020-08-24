/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fun_grad.c
 *
 * Code generation for function 'fun_grad'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "fun_grad.h"
#include "mrdivide.h"
#include "eye.h"

/* Function Definitions */
void fun_grad(const creal_T s[80], const creal_T A0[6400], const creal_T phi_S
              [6400], const creal_T K, const creal_T q[3], const creal_T Ak
              [19200], creal_T df[80])
{
  static creal_T roujia_v2[6400];
  double I_len_s[6400];
  int i0;
  int i1;
  static creal_T dss[6400];
  static creal_T b_phi_S[6400];
  static creal_T a[6400];
  creal_T b_s[80];
  creal_T roujia_v1[80];
  double A0_re;
  double A0_im;
  int i;
  static creal_T b_q[6400];
  static creal_T c_q[6400];
  int i2;
  static creal_T b_Ak[6400];
  double re;
  double im;
  (void)K;
  memset(&roujia_v2[0], 0, 6400U * sizeof(creal_T));
  eye(I_len_s);
  for (i0 = 0; i0 < 80; i0++) {
    for (i1 = 0; i1 < 80; i1++) {
      dss[i1 + 80 * i0].re = A0[i0 + 80 * i1].re;
      dss[i1 + 80 * i0].im = -A0[i0 + 80 * i1].im;
    }
  }

  for (i0 = 0; i0 < 6400; i0++) {
    b_phi_S[i0].re = phi_S[i0].re + I_len_s[i0];
    b_phi_S[i0].im = phi_S[i0].im;
  }

  mrdivide(dss, b_phi_S, a);
  for (i0 = 0; i0 < 80; i0++) {
    b_s[i0].re = 0.0;
    b_s[i0].im = 0.0;
    for (i1 = 0; i1 < 80; i1++) {
      A0_re = A0[i0 + 80 * i1].re;
      A0_im = -A0[i0 + 80 * i1].im;
      b_s[i0].re += s[i1].re * A0_re - -s[i1].im * A0_im;
      b_s[i0].im += s[i1].re * A0_im + -s[i1].im * A0_re;
    }
  }

  for (i0 = 0; i0 < 6400; i0++) {
    b_phi_S[i0].re = phi_S[i0].re + I_len_s[i0];
    b_phi_S[i0].im = phi_S[i0].im;
  }

  b_mrdivide(b_s, b_phi_S, roujia_v1);

  /* roujia_v3 = ctranspose(s) * ctranspose(A0) / (phi_S + eye(len_s)); */
  /*      for i = 1:len_s */
  /*          roujia_loop_ans(:,:) = 0; */
  /*          roujia = bsxfun(@times,Ak(:,i,:), s'); */
  /*          for k = 1:K   */
  /*              %roujia_acc = Ak(:,i,k) * s' * Ak(:,:,k)';  */
  /*              roujia_acc = roujia(:,:,k)* Ak(:,:,k)';  */
  /*              roujia_loop_ans = roujia_loop_ans + q(k) * (roujia_acc + roujia_acc'); */
  /*          end */
  /*          */
  /*          roujia_v2(i,:) = roujia_v1 * roujia_loop_ans; */
  /*      end */
  /*      for k = 1:K   */
  /*          %roujia_loop_ans(:,:) = 0; */
  /*          parfor i = 1:len_s */
  /*              dss(:,:) = 0; */
  /*              dss(:,i) = s;%+  conjugate */
  /*              dss(i,:) = s'; */
  /*              dss(i,i) = 2 * (real(s(i))); */
  /*              %dss = sparse(dss); */
  /*              roujia_loop_ans = q(k) * Ak(:,:,k)* dss * Ak(:,:,k)'; */
  /*              roujia_v2(i,:) = roujia_v2(i,:) + roujia_v1 * roujia_loop_ans; */
  /*          end */
  /*      end */
  /* roujia_vec = repmat(ctranspose(roujia_v1),[1,len_s]); */
  /* df = (first_term + last_term)-4*1000*100*s; */
  /* df = (first_term + last_term) - 4 * s; */
  for (i = 0; i < 80; i++) {
    for (i0 = 0; i0 < 6400; i0++) {
      dss[i0].re = 0.0;
      dss[i0].im = 0.0;
    }

    memcpy(&dss[i * 80], &s[0], 80U * sizeof(creal_T));

    /* +  conjugate */
    for (i0 = 0; i0 < 80; i0++) {
      dss[i + 80 * i0].re = s[i0].re;
      dss[i + 80 * i0].im = -s[i0].im;
    }

    dss[i + 80 * i].re = 2.0 * s[i].re;
    dss[i + 80 * i].im = 0.0;

    /* dss = sparse(dss); */
    for (i0 = 0; i0 < 80; i0++) {
      for (i1 = 0; i1 < 80; i1++) {
        b_q[i1 + 80 * i0].re = ((q[0].re * Ak[i1 + 80 * i0].re - q[0].im * Ak[i1
          + 80 * i0].im) + (q[1].re * Ak[6400 + (i1 + 80 * i0)].re - q[1].im *
                            Ak[6400 + (i1 + 80 * i0)].im)) + (q[2].re * Ak[12800
          + (i1 + 80 * i0)].re - q[2].im * Ak[12800 + (i1 + 80 * i0)].im);
        b_q[i1 + 80 * i0].im = ((q[0].re * Ak[i1 + 80 * i0].im + q[0].im * Ak[i1
          + 80 * i0].re) + (q[1].re * Ak[6400 + (i1 + 80 * i0)].im + q[1].im *
                            Ak[6400 + (i1 + 80 * i0)].re)) + (q[2].re * Ak[12800
          + (i1 + 80 * i0)].im + q[2].im * Ak[12800 + (i1 + 80 * i0)].re);
      }
    }

    for (i0 = 0; i0 < 80; i0++) {
      for (i1 = 0; i1 < 80; i1++) {
        c_q[i0 + 80 * i1].re = 0.0;
        c_q[i0 + 80 * i1].im = 0.0;
        for (i2 = 0; i2 < 80; i2++) {
          c_q[i0 + 80 * i1].re += b_q[i0 + 80 * i2].re * dss[i2 + 80 * i1].re -
            b_q[i0 + 80 * i2].im * dss[i2 + 80 * i1].im;
          c_q[i0 + 80 * i1].im += b_q[i0 + 80 * i2].re * dss[i2 + 80 * i1].im +
            b_q[i0 + 80 * i2].im * dss[i2 + 80 * i1].re;
        }

        b_Ak[i1 + 80 * i0].re = (Ak[i0 + 80 * i1].re + Ak[6400 + (i0 + 80 * i1)]
          .re) + Ak[12800 + (i0 + 80 * i1)].re;
        b_Ak[i1 + 80 * i0].im = (-Ak[i0 + 80 * i1].im + -Ak[6400 + (i0 + 80 * i1)]
          .im) + -Ak[12800 + (i0 + 80 * i1)].im;
      }
    }

    for (i0 = 0; i0 < 80; i0++) {
      for (i1 = 0; i1 < 80; i1++) {
        b_q[i0 + 80 * i1].re = 0.0;
        b_q[i0 + 80 * i1].im = 0.0;
        for (i2 = 0; i2 < 80; i2++) {
          b_q[i0 + 80 * i1].re += c_q[i0 + 80 * i2].re * b_Ak[i2 + 80 * i1].re -
            c_q[i0 + 80 * i2].im * b_Ak[i2 + 80 * i1].im;
          b_q[i0 + 80 * i1].im += c_q[i0 + 80 * i2].re * b_Ak[i2 + 80 * i1].im +
            c_q[i0 + 80 * i2].im * b_Ak[i2 + 80 * i1].re;
        }
      }
    }

    b_s[i].re = 0.0;
    b_s[i].im = 0.0;
    A0_re = 0.0;
    A0_im = 0.0;
    for (i0 = 0; i0 < 80; i0++) {
      re = 0.0;
      im = 0.0;
      for (i1 = 0; i1 < 80; i1++) {
        re += roujia_v1[i1].re * b_q[i1 + 80 * i0].re - roujia_v1[i1].im *
          b_q[i1 + 80 * i0].im;
        im += roujia_v1[i1].re * b_q[i1 + 80 * i0].im + roujia_v1[i1].im *
          b_q[i1 + 80 * i0].re;
      }

      roujia_v2[i + 80 * i0].re += re;
      roujia_v2[i + 80 * i0].im += im;
      b_phi_S[i + 80 * i0].re = 0.0;
      b_phi_S[i + 80 * i0].im = 0.0;
      for (i1 = 0; i1 < 80; i1++) {
        b_phi_S[i + 80 * i0].re += a[i + 80 * i1].re * A0[i1 + 80 * i0].re - a[i
          + 80 * i1].im * A0[i1 + 80 * i0].im;
        b_phi_S[i + 80 * i0].im += a[i + 80 * i1].re * A0[i1 + 80 * i0].im + a[i
          + 80 * i1].im * A0[i1 + 80 * i0].re;
      }

      b_s[i].re += b_phi_S[i + 80 * i0].re * s[i0].re - b_phi_S[i + 80 * i0].im *
        s[i0].im;
      b_s[i].im += b_phi_S[i + 80 * i0].re * s[i0].im + b_phi_S[i + 80 * i0].im *
        s[i0].re;
      A0_re += roujia_v2[i + 80 * i0].re * roujia_v1[i0].re - roujia_v2[i + 80 *
        i0].im * -roujia_v1[i0].im;
      A0_im += roujia_v2[i + 80 * i0].re * -roujia_v1[i0].im + roujia_v2[i + 80 *
        i0].im * roujia_v1[i0].re;
    }

    df[i].re = 2.0 * b_s[i].re + A0_re;
    df[i].im = 2.0 * b_s[i].im + A0_im;
  }
}

/* End of code generation (fun_grad.c) */

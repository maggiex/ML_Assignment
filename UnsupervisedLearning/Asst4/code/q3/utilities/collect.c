#include "mex.h"

/* Y = collect(X,d,m,k) returns:
 * let s = size(X)
 * then size(Y) = [s(1)...s(d-1) m s(d+1)...s(end)], and
 * Y(i(1)...i(d-1),j,i(d+1)...i(end)) 
 * = sum_i(d) (k(i(d))==j) * X(i(1)...i(end))
 */
#define mxX prhs[0] 
#define mxDIM prhs[1] 
#define mxMAX prhs[2] 
#define mxINDEX prhs[3] 
#define mxY plhs[0]

void errormessage(char *str) {
  mexPrintf("Collect X dim maxindex index.\n");
  mexErrMsgTxt(str);
}
void mexFunction( int nlhs, mxArray *plhs[], 
                              int nrhs, const mxArray*prhs[] )
{
  double *xx, *yy, *index; 
  const mwSize *size;
  mwSize ndim, *ysize, dim;
  int size1, xsize2, size3, ysize2;
  int ii, jj, kk, ll, mm, xk, yk, yl, xj;

  if ( ! ( mxIsDouble(mxX) && mxIsDouble(mxDIM) && mxIsDouble(mxMAX) && 
           mxIsDouble(mxINDEX) ) ) errormessage("arguments has to be double");
  xx = mxGetPr(mxX);
  ndim = mxGetNumberOfDimensions(mxX);
  size = mxGetDimensions(mxX);

  if ( mxGetNumberOfElements(mxDIM) != 1 ) 
    errormessage("dim has to be scalar");
  dim = *mxGetPr(mxDIM);
  if ( dim <= 0 || (double) dim != *mxGetPr(mxDIM) ) 
    errormessage("dim has to be positive scalar");
  size1 = size3 = 1;
  if ( dim <= ndim ) {
    xsize2 = size[dim-1];
    for ( ii = 0   ; ii < dim-1 ; ii ++ ) size1 *= size[ii];
    for ( ii = dim ; ii < ndim  ; ii ++ ) size3 *= size[ii];
  } else {
    xsize2 = 1;
    for ( ii = 0   ; ii < ndim  ; ii ++ ) size1 *= size[ii];
  }
  
  if ( mxGetNumberOfElements(mxMAX) != 1 )
    errormessage("max has to be scalar");
  ysize2 = *mxGetPr(mxMAX);
  if ( ysize2 < 0 || (double) ysize2 != *mxGetPr(mxMAX) )
    errormessage("max has to be non-negative scalar");

  if ( mxGetNumberOfElements(mxINDEX) != xsize2 )
    errormessage("number of indices has to be equal to size of X on that dim");
  index = mxGetPr(mxINDEX);
  for ( ii = 0 ; ii < xsize2 ; ii ++ ) {
    ll = index[ii];
    if ( ll < 1 || ll > ysize2 || (double) ll != index[ii] )
      errormessage("indices have to be >= 1, <= max and integers");
  }

  if ( dim <= ndim ) {
    ysize = mxMalloc(sizeof(int) * ndim);
    for ( ii = 0 ; ii < ndim ; ii ++ ) ysize[ii] = size[ii];
    ysize[dim-1] = ysize2;
    mm = ndim;
  } else {
    ysize = mxMalloc(sizeof(int) * dim);
    for ( ii = 0    ; ii < ndim   ; ii ++ ) ysize[ii] = size[ii];
    for ( ii = ndim ; ii < dim-1  ; ii ++ ) ysize[ii] = 1;
    ysize[dim-1] = ysize2;
    mm = dim;
  }

  mxY = mxCreateNumericArray(mm,ysize,mxDOUBLE_CLASS,mxREAL);
  yy = mxGetPr(mxY);
  mm = size1 * ysize2 * size3;
  for ( ii = 0 ; ii < mm ; ii ++ ) yy[ii] = 0;

  for ( kk = 0 ; kk < size3 ; kk ++ ) {
    yk = kk * size1 * ysize2;
    xk = kk * size1 * xsize2;
    for ( jj = 0 ; jj < xsize2 ; jj ++ ) {
      ll = index[jj]-1;
      yl = ll * size1 + yk;
      xj = jj * size1 + xk;
      for ( ii = 0 ; ii < size1 ; ii ++ ) 
        yy[ii+yl] += xx[ii+xj];
    }
  }
}

  



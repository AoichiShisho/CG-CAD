///////////////////////////////////////////////////////////////////////////////////
// Affine Transformation
///////////////////////////////////////////////////////////////////////////////////
// unit matrix
void init_matrix(float[][] M) {
  M[0][0]=1; M[0][1]=0; M[0][2]=0; M[0][3]=0;
  M[1][0]=0; M[1][1]=1; M[1][2]=0; M[1][3]=0;
  M[2][0]=0; M[2][1]=0; M[2][2]=1; M[2][3]=0;
  M[3][0]=0; M[3][1]=0; M[3][2]=0; M[3][3]=1;
}

// translation
void matrix_translate(float[][] M, float x, float y, float z) {
  init_matrix(M);
  M[3][0]=x; M[3][1]=y; M[3][2]=z;
}

// rotation
void matrix_rotate(float[][] M, char axis, float theta) {
  init_matrix(M);
  if( axis=='x'||axis=='X' ) {
    M[1][1]= cos(theta);
    M[1][2]= sin(theta);
    M[2][1]=-sin(theta);
    M[2][2]= cos(theta);
  } else if( axis=='y'||axis=='Y' ) {
    M[2][2]= cos(theta);
    M[2][0]= sin(theta);
    M[0][2]=-sin(theta);
    M[0][0]= cos(theta);
  } else if( axis=='z'||axis=='Z' ) {
    M[0][0]= cos(theta);
    M[0][1]= sin(theta);
    M[1][0]=-sin(theta);
    M[1][1]= cos(theta);
  }
}

// scale
void matrix_scale(float[][] M, float x, float y, float z) {
  init_matrix(M);
  M[0][0]=x; M[1][1]=y; M[2][2]=z;
}

import processing.opengl.*;

class CVector {
  
  // 1. Vector
  float x;
  float y;
  float z;
  
  // Constructor
  CVector() { x=0.0; y=0.0; z=0.0; }
  
  void add( CVector Q, CVector result ) {
    result.x = x + Q.x;
    result.y = y + Q.y;
    result.z = z + Q.z;
  }
  
  void sub( CVector Q, CVector result ) {
    result.x = x - Q.x;
    result.y = y - Q.y;
    result.z = z - Q.z;
  }
  
  void mult( float n, CVector result ) {
    result.x = x * n;
    result.y = y * n;
    result.z = z * n;
  }
  
  void div( float n, CVector result ) {
    result.x = x / n;
    result.y = y / n;
    result.z = z / n;
  }
    
  float mag() {
    return (float)sqrt( x * x + y * y + z * z ); 
  }
  
  void normalize(CVector result) {
    float m = mag();
    if ( m != 0 ) div(m, result);
  }
  
  float dot( CVector Q ) {
    return x*Q.x + y*Q.y + z*Q.z;
  }
  
  void proj(CVector Q, CVector result) {
    float d = dot(Q);
    float Q2 = Q.x*Q.x + Q.y*Q.y + Q.z*Q.z;
    Q.mult(d/Q2, result);
  }
  
  void perp(CVector Q, CVector result) {
    proj(Q, result);
    sub(result, result);
  }
  
  void cross( CVector v, CVector result ) {
     result.x = y * v.z - v.y * z;
     result.y = z * v.x - v.z * x;
     result.z = x * v.y - v.x * y;
  }
  
  void draw(String name, color col) {
    stroke(col);  fill(col);
    line(0, 0, 0, x, y, z);
    pushMatrix();  
      translate(x, y, z); 
      PMatrix3D bMat = (PMatrix3D)g.getMatrix();  
      bMat.m00 = bMat.m11 = bMat.m22 = 1;  
      bMat.m00 = 1; bMat.m01 = 0; bMat.m02 = 0;
      bMat.m10 = 0; bMat.m11 = 1; bMat.m12 = 0;
      bMat.m20 = 0; bMat.m21 = 0; bMat.m22 = 1;
      resetMatrix();  
      applyMatrix(bMat);  
      textAlign(CENTER);  
      text("" +name, 0, 0);  
    popMatrix();
  }
}

CVector P, Q, P_ADD_Q, P_SUB_Q, P_MUL_N, P_DIV_N, P_NORMALIZED, Q_NORMALIZED;
CVector projQP, perpQP, P_CROSS_Q;

void setup() {
  size(400, 400, OPENGL);  
  
  P = new CVector();
  Q = new CVector();
  P_ADD_Q = new CVector();
  P_SUB_Q = new CVector();
  P_MUL_N = new CVector();
  P_DIV_N = new CVector();
  P_NORMALIZED = new CVector();
  Q_NORMALIZED = new CVector();
  projQP = new CVector();
  perpQP = new CVector();
  P_CROSS_Q = new CVector();
  
  Q.x = 50; Q.y = 0;
  
}

void draw() {
  background(40);
  P.x = 25; P.y = 50;
  
  //!-----OPERATION------!//
  P.add(Q, P_ADD_Q);
  P.sub(Q, P_SUB_Q);
  P.mult(2, P_MUL_N);
  P.div(2, P_DIV_N);
  P.normalize(P_NORMALIZED);
  Q.normalize(Q_NORMALIZED);
  fill(255);
  text("|P|="+P.mag(), 60, 30);
  text("Pn.Qn="+P_NORMALIZED.dot(Q_NORMALIZED), 60, 60);
  P.proj(Q, projQP);
  P.perp(Q, perpQP);
  P.cross(Q, P_CROSS_Q);
  P_CROSS_Q.normalize(P_CROSS_Q);
  P_CROSS_Q.mult(50, P_CROSS_Q);
      
  translate(width/2, height/2);
  rotateX(map(mouseY, 0, height, 0, TWO_PI));
  rotateY(map(mouseX, 0, width, 0, TWO_PI));
  
  //!-----DRAW------!// 
  noStroke();    
  fill(100, 100, 100);
  triangle(P.x, P.y, Q.x, Q.y, 0, 0);
 
  P.draw("P", color(255, 255, 255));
  Q.draw("Q", color(255, 255, 255));
  
  P_ADD_Q.draw("P+Q", color(255, 255, 0));
  P_SUB_Q.draw("P-Q", color(255, 255, 0));
  P_MUL_N.draw("P*2", color(0, 255, 255));
  P_DIV_N.draw("P/2", color(0, 255, 255));
  P_NORMALIZED.draw("Pn", color(255, 255, 255));
  projQP.draw("projQP", color(255, 0, 255));
  perpQP.draw("perpQP", color(255, 0, 255));
  P_CROSS_Q.draw("PxQ", color(255, 0, 0));
  
}



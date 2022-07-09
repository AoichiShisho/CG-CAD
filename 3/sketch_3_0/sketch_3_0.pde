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
    result.x = n * x;
    result.y = n * y;
    result.z = n * z;
  }
  
  void div( float n, CVector result ) {
    result.x = x / n;
    result.y = y / n;
    result.z = z / n;
  }
    
  float mag() {
    return (float)sqrt(x*x + y*y + z*z);
//    return 0;
  }
  
  void normalize(CVector result) {
    float m = mag();
    if ( m != 0 ) div(m, result);
  }
  
  float dot( CVector v ) {
    return x*v.x + y*v.y + z*v.z;
    // return 0;   
  }
  
  void proj(CVector Q, CVector result) {
    float d = dot(Q);
    float Q2 = Q.x*Q.x + Q.y*Q.y + Q.z*Q.z;
    Q.mult(d/Q2, result);
  }
  
  void perp(CVector Q, CVector result) {
    proj(Q, result);
    sub(result ,result);
  }
    
  void draw(String name, color col) {
    stroke(col);  fill(col);
    line(0, 0, x, y);
    pushMatrix();
      translate(x, y);
      rotate(atan2(x-0, 0-y));
      line(0, 0, 2, 2);
      line(0, 0, -2, 2);
    popMatrix();
    
    text(" "+name, x, y);
  }
}

CVector v0, v1, v2, v3, v4, v5, v6, v7, v8, v9;

void setup() {
  size(400, 400);  
  
  v0=new CVector(); v1=new CVector(); v2=new CVector();
  v3=new CVector(); v4=new CVector(); v5=new CVector();
  v6=new CVector(); v7=new CVector(); v8=new CVector();
  v9=new CVector();
  
  v1.x = 50; v1.y = 25;
  
}

void draw() {
  background(40);
  
  v0.x = mouseX-width/2; v0.y = mouseY-height/2;
  
  v0.add(v1, v2);
  v0.sub(v1, v3);
  v0.mult(2, v4);
  v0.div(2, v5);
  v0.normalize(v6);
  v1.normalize(v7);
  v0.proj(v1, v8);
  v0.perp(v1, v9);

  fill(255);
  text("|P|="+v0.mag(), 30, 30);
  text("P/|P| dot Q/|Q|="+ v6.dot(v7), 30, 50);

  translate(width/2, height/2);

  v0.draw("v0", color(255,0,0));
  v1.draw("v1", color(0, 255, 0));  

  v2.draw("v0+v1", color(0,0,255));
  v3.draw("v0-v1", color(0, 255, 255));
  v4.draw("v0*2", color(255, 255, 255));
  v5.draw("v0/2", color(255, 255, 255));

  v6.draw("v0/|v0|", color(0, 255, 255));

  v8.draw("projqP", color(255, 0, 255));
  v9.draw("perpqP", color(255, 0, 255));
}

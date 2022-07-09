class BezierCurve {
  
  PVector P0, P1, P2, P3;
  PVector[] R;
  PVector[] D1;
  PVector[] D2;
  PVector[] e1;
  PVector[] e2;
  float[] K;
  int tn;
  
  BezierCurve() {
    P0 = new PVector(); P0.x =  20; P0.y = 300;
    P1 = new PVector(); P1.x = 140; P1.y = 100;
    P2 = new PVector(); P2.x = 280; P2.y = 100;
    P3 = new PVector(); P3.x = 380; P3.y = 300;
    
    tn = 50;
    R  = new PVector[tn];
    D1 = new PVector[tn];
    D2 = new PVector[tn];
    e1 = new PVector[tn];
    e2 = new PVector[tn];
    K  = new float[tn];
  }
  
  void draw() {
    
    int   i, tt;
    float t=0.0;
    float ts = (float)1 / tn;
    float B30t, B31t, B32t, B33t;

    stroke(0, 255, 255);
    fill(0, 255, 255, 30);
    quad(P0.x, P0.y, P1.x, P1.y, P2.x, P2.y, P3.x, P3.y);
    line(P0.x, P0.y, P1.x, P1.y);
    line(P1.x, P1.y, P2.x, P2.y);
    line(P2.x, P2.y, P3.x, P3.y);
    
    fill(0, 255, 255);
    ellipse(P0.x, P0.y, 5, 5);
    ellipse(P1.x, P1.y, 5, 5);
    ellipse(P2.x, P2.y, 5, 5);
    ellipse(P3.x, P3.y, 5, 5);
    
    // text control points 
    fill(255, 255, 255);
    text("P0", P0.x+15, P0.y   ); // p0
    text("P1", P1.x,    P1.y-15); // p1
    text("P2", P2.x+10, P2.y-15); // p2
    text("P3", P3.x-30, P3.y   ); // p3    
    
    noFill();
    stroke(255, 255, 255);
    
    for(tt = 0; tt < tn ; tt+=1) {
        B30t =     (1-t)*(1-t)*(1-t)        ; 
        B31t = 3 * (1-t)*(1-t)       *t     ;
        B32t = 3 * (1-t)             *t*t   ; 
        B33t =                        t*t*t ;
        R[tt] = new PVector();
        R[tt].x = B30t*P0.x + B31t*P1.x + B32t*P2.x + B33t*P3.x;
        R[tt].y = B30t*P0.y + B31t*P1.y + B32t*P2.y + B33t*P3.y;      
      if (tt != 0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);
      t = t + ts;
    }
    
    PVector Q0, Q1, Q2;
    Q0=new PVector(); Q0.x=3*(P1.x-P0.x); Q0.y=3*(P1.y-P0.y);
    Q1=new PVector(); Q1.x=3*(P2.x-P1.x); Q1.y=3*(P2.y-P1.y);
    Q2=new PVector(); Q2.x=3*(P3.x-P2.x); Q2.y=3*(P3.y-P2.y);

    PVector W0, W1;
    W0=new PVector(); W0.x=(3-1)*(Q1.x-Q0.x); W0.y=(3-1)*(Q1.y-Q0.y);
    W1=new PVector(); W1.x=(3-1)*(Q2.x-Q1.x); W1.y=(3-1)*(Q2.y-Q1.y);

    float B20t, B21t, B22t; 
    float B10t, B11t;
    PVector temp = new PVector();
        
    t=0;
    for(tt=0;tt<tn;tt=tt+1) {
      B20t =     (1-t)*(1-t)    ; 
      B21t = 2 *       (1-t)  *t;
      B22t =                 t*t;  
    
      B10t = 1-t;
      B11t =   t;  
      
      // First Derivate D1
      D1[tt]=new PVector();
      D1[tt].x=B20t*Q0.x + B21t*Q1.x + B22t*Q2.x;
      D1[tt].y=B20t*Q0.y + B21t*Q1.y + B22t*Q2.y;    
    
      // Second Derivate D2
      D2[tt]=new PVector();
      D2[tt].x=B10t*W0.x + B11t*W1.x;
      D2[tt].y=B10t*W0.y + B11t*W1.y;
            
      // Basis Vector e1
      e1[tt]=new PVector();
      e1[tt].x=D1[tt].x; e1[tt].y=D1[tt].y;
      e1[tt].normalize();
      
      // draw tangent vector
      temp.x=e1[tt].x; temp.y=e1[tt].y; temp.mult(100);
      stroke(255, 125, 0);
      if(tt!=0)line(R[tt].x, R[tt].y, R[tt].x+temp.x, R[tt].y+temp.y);
      
      // Basis Vector e2
      e2[tt] = new PVector();
      e2[tt].x = e1[tt].x; 
      e2[tt].y = e1[tt].y;
      e2[tt].rotate(HALF_PI);
      
      // draw normal vector
      temp.x = e2[tt].x; 
      temp.y = e2[tt].y; 
      temp.mult(100);
      stroke(0, 255, 125);
      if(tt!=0)line(R[tt].x, R[tt].y, R[tt].x+temp.x, R[tt].y+temp.y);
      
      // Curvature K
      K[tt] = (D1[tt].x*D2[tt].y - D2[tt].x*D1[tt].y)/
            (sqrt(D1[tt].x*D1[tt].x + D1[tt].y*D1[tt].y)*
              (D1[tt].x*D1[tt].x + D1[tt].y*D1[tt].y));
      
      // Circule of Curvature 
      stroke(255, 255, 0);
      ellipseMode(RADIUS);
      temp.x = e2[tt].x; 
      temp.y = e2[tt].y;
      float KR = (float)1/K[tt];
      
      float a = temp.x-((1+D1[tt].x*D1[tt].x)*D1[tt].x)/D2[tt].x;
      float b = R[tt].x+(1+D1[tt].x*D1[tt].x)/D2[tt].x;
      
      temp.mult(100);
      //ellipse(a, b, KR, KR);
      ellipse(R[tt].x + temp.x, R[tt].y + temp.y, KR, KR);
      
      t=t+ts;   
    } 
  }
}

BezierCurve b0;
void setup() {
  size(400, 400);
  b0 = new BezierCurve();
}

void draw() {
  background(40);
  
  text("BezierCurve First and second Deriatives and Curvature", 10, 20);
  
  b0.P0.x = mouseX; b0.P0.y = mouseY;
  
  b0.draw();
}

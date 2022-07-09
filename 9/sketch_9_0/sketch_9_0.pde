import processing.opengl.*;

class BezierSurface {
  
  PVector P03, P13, P23, P33;
  PVector P02, P12, P22, P32;
  PVector P01, P11, P21, P31;
  PVector P00, P10, P20, P30;
  PVector[][] S;
  int un, vn;
  
  BezierSurface() {
    P03 = new PVector(-150,  0, -150);  P13 = new PVector(-50, 40, -150);  P23 = new PVector(50, 40, -150);  P33 = new PVector(150,  0, -150); 
    P02 = new PVector(-150, 40,  -50);  P12 = new PVector(-50, 80,  -50);  P22 = new PVector(50, 80,  -50);  P32 = new PVector(150, 40,  -50); 
    P01 = new PVector(-150, 40,   50);  P11 = new PVector(-50, 80,   50);  P21 = new PVector(50, 80,   50);  P31 = new PVector(150, 40,   50); 
    P00 = new PVector(-150,  0,  150);  P10 = new PVector(-50, 40,  150);  P20 = new PVector(50, 40,  150);  P30 = new PVector(150,  0,  150); 
    
    un = 4;
    vn = 4;
    
    S = new PVector[un+1][vn+1];
    for (int i=0; i<un+1; i++) 
      for (int j=0; j<vn+1; j++)
        S[i][j] = new PVector();
        
  }
  
  void CtrlPt(PVector P) { pushMatrix(); translate(P.x, P.y, P.z); box(2); popMatrix(); }
  void Edge(PVector P0, PVector P1) { line(P0.x, P0.y, P0.z, P1.x, P1.y, P1.z); }
  
  float B30(float t) { return     ((1-t)*(1-t)*(1-t));        }
  float B31(float t) { return (3 * (1-t)*(1-t)         *t  ); }
  float B32(float t) { return (3 * (1-t)               *t*t); }
  float B33(float t) { return                        (t*t*t); }
  
  void draw(color c) {
    
    stroke(0, 255, 255);
    CtrlPt(P03); CtrlPt(P13); CtrlPt(P23); CtrlPt(P33); 
    CtrlPt(P02); CtrlPt(P12); CtrlPt(P22); CtrlPt(P32);
    CtrlPt(P01); CtrlPt(P11); CtrlPt(P21); CtrlPt(P31);
    CtrlPt(P00); CtrlPt(P10); CtrlPt(P20); CtrlPt(P30);
    
    Edge(P03, P13); Edge(P13, P23); Edge(P23, P33);
    Edge(P02, P12); Edge(P12, P22); Edge(P22, P32);
    Edge(P01, P11); Edge(P11, P21); Edge(P21, P31);
    Edge(P00, P10); Edge(P10, P20); Edge(P20, P30);
    
    Edge(P00, P01); Edge(P01, P02); Edge(P02, P03);
    Edge(P10, P11); Edge(P11, P12); Edge(P12, P13);
    Edge(P20, P21); Edge(P21, P22); Edge(P22, P23);
    Edge(P30, P31); Edge(P31, P32); Edge(P32, P33);
    
    int   i, uu, vv;
    float u, v;
    float us = (float)1/un;
    float vs = (float)1/vn;
    
    stroke(c);
              
    u=0;
    for(uu=0; uu<=un; uu+=1) {
        v=0; 
        for(vv=0; vv<=vn; vv+=1) {
          S[uu][vv].x = B30(u)*(B30(v)*P00.x + B31(v)*P01.x + B32(v)*P02.x + B33(v)*P03.x)
                      + B31(u)*(B30(v)*P10.x + B31(v)*P11.x + B32(v)*P12.x + B33(v)*P13.x)
                      + B32(u)*(B30(v)*P20.x + B31(v)*P21.x + B32(v)*P22.x + B33(v)*P23.x)
                      + B33(u)*(B30(v)*P30.x + B31(v)*P31.x + B32(v)*P32.x + B33(v)*P33.x);                     
          S[uu][vv].y = B30(u)*(B30(v)*P00.y + B31(v)*P01.y + B32(v)*P02.y + B33(v)*P03.y)
                      + B31(u)*(B30(v)*P10.y + B31(v)*P11.y + B32(v)*P12.y + B33(v)*P13.y)
                      + B32(u)*(B30(v)*P20.y + B31(v)*P21.y + B32(v)*P22.y + B33(v)*P23.y)
                      + B33(u)*(B30(v)*P30.y + B31(v)*P31.y + B32(v)*P32.y + B33(v)*P33.y);                     
          S[uu][vv].z = B30(u)*(B30(v)*P00.z + B31(v)*P01.z + B32(v)*P02.z + B33(v)*P03.z)
                      + B31(u)*(B30(v)*P10.z + B31(v)*P11.z + B32(v)*P12.z + B33(v)*P13.z)
                      + B32(u)*(B30(v)*P20.z + B31(v)*P21.z + B32(v)*P22.z + B33(v)*P23.z)
                      + B33(u)*(B30(v)*P30.z + B31(v)*P31.z + B32(v)*P32.z + B33(v)*P33.z); 
          
          if (uu>0 && vv>0) {
            beginShape();
              vertex(S[uu  ][vv  ].x, S[uu  ][vv  ].y, S[uu  ][vv  ].z);
              vertex(S[uu-1][vv  ].x, S[uu-1][vv  ].y, S[uu-1][vv  ].z);
              vertex(S[uu-1][vv-1].x, S[uu-1][vv-1].y, S[uu-1][vv-1].z);
              vertex(S[uu  ][vv-1].x, S[uu  ][vv-1].y, S[uu  ][vv-1].z);
            endShape();
          }          
          v = v + vs;
        }
      u = u + us; 
    }
    
    
    
  }
  
}


BezierSurface b0;

void setup() {
  size(500, 500, OPENGL);
  b0 = new BezierSurface();
}

float ang=0;

void draw() {
  background(40);
  text("Bicubic Bezier Surface", 10, 20);
  
  lights();  
  translate(width/2, height/2);
  rotateX(map(-mouseY, 0, width, -PI, PI));
  rotateY(map(mouseX, 0, height, -PI, PI));
  
  b0.draw(color(255, 255, 255));  
  //noLoop();
}




import processing.opengl.*;

class BezierSurface {
  
  int ud, vd;
  PVector[][] P;
  PVector[][] S;
  int un, vn;
  
  float[][] w;

  BezierSurface(float n, float m) {
    
    int i, j;
    
    ud = (int)n;
    vd = (int)m;
    
    P = new PVector[ud+1][vd+1];
    for(i=0; i<ud+1; i++)
      for(j=0; j<vd+1; j++)
        P[i][j] = new PVector(-150+300/ud*i, abs(i-ud/2.0)*20+abs(j-vd/2.0)*20+random(-40,40), -150+300/vd*j);

    w = new float[ud+1][vd+1];
    for(i=0; i<ud+1; i++)
      for(j=0; j<vd+1; j++)
        w[i][j] = 1.0;

    un = 10;
    vn = 10;
    
    S = new PVector[un+1][vn+1];
    for (i=0; i<un+1; i++) 
      for (j=0; j<vn+1; j++)
        S[i][j] = new PVector();
        
  }
  
  void CtrlPt(PVector P) { 
    pushMatrix(); translate(P.x, P.y, P.z); box(2); popMatrix(); 
  }
  
  void Edge(PVector P0, PVector P1) { 
    line(P0.x, P0.y, P0.z, P1.x, P1.y, P1.z); 
  }
  
  float B(int n ,int i, float t) {
    return fact(n)/(fact(i)*fact(n-i) ) * pow(1-t, n-i) * pow(t, i); 
  }
  
  void drawSurface(color c) {
  
    int   i, j, uu, vv;
    float u, v;
    float us = (float)1/un;
    float vs = (float)1/vn;
    
    stroke(0, 255, 255);
    for(i=0; i<ud+1; i++)
      for(j=0; j<vd+1; j++)
        CtrlPt(P[i][j]);
    
    for(i=0; i<ud+1; i++)
      for(j=0; j<vd+0; j++)
        Edge(P[i][j], P[i][j+1]);
    
    for(i=0; i<ud+0; i++)
      for(j=0; j<vd+1; j++)
        Edge(P[i][j], P[i+1][j]);

    stroke(c);
    
    u=0;
    for(uu=0; uu<=un; uu+=1) {
        v=0; 
        for(vv=0; vv<=vn; vv+=1) {
          
          float sum = 0;
          for(i=0; i<ud+1; i++)
            for(j=0; j<vd+1; j++)
              sum += B(ud, i, u) * B(vd, j, v) * w[i][j];
              
          S[uu][vv].x = 0;
          S[uu][vv].y = 0;
          S[uu][vv].z = 0;
          for(i=0; i<ud+1; i++){
            for(j=0; j<vd+1; j++){
              S[uu][vv].x += B(ud, i, u) * B(vd, j, v) * w[i][j] * P[i][j].x / sum;
              S[uu][vv].y += B(ud, i, u) * B(vd, j, v) * w[i][j] * P[i][j].y / sum;
              S[uu][vv].z += B(ud, i, u) * B(vd, j, v) * w[i][j] * P[i][j].z / sum;
            }
          }

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

int fact (int nth) {
  int f = 1;
  for (int k = 1; k < nth+1; k++)
    f = f * k;
  return f;
}

class Interface {

  PFont sst;
  int n, m;
  
  Interface(int ud, int vd) {
    n = ud;
    m = vd;
    sst = loadFont("SST-Medium-24.vlw");
    textFont(sst, 24);
  }
  
  void drawNavi(BezierSurface b) {
    text("Degree: " + n + " x " + m, 10, 30);
    text("click to refresh.", 270, 30);
    text("Center Weight: " + nfc(b.w[b0.ud/2][b0.vd/2], 2), 10, 60);
    text("w / W to change.", 270, 60);
  }
}

BezierSurface b0;
Interface i0;

void setup() {
  size(500, 500, OPENGL);
  b0 = new BezierSurface(random(2, 9), random(2, 9));
  i0 = new Interface(b0.ud, b0.vd);
}

void draw() {
  background(40);
  i0.drawNavi(b0);

  lights();  
  translate(width/2, height/2);
  rotateX(map(-mouseY, 0, width, -PI, PI));
  rotateY(map(mouseX, 0, height, -PI, PI));
  
  b0.drawSurface(color(255, 255, 255));
  stroke(  0, 255,  0);  line(0,0,0,200,  0,  0);  text("X",180,  0,  0);
  stroke(255,   0,  0);  line(0,0,0,  0,200,  0);  text("Y",  0,190,  0);
  stroke(  0,   0,255);  line(0,0,0,  0,  0,200);  text("Z",  0,  0,200);
}

void keyPressed() {
  int uc = b0.ud/2;
  int vc = b0.vd/2;
  float ws=0.0;
  
  if (key=='w') ws= 0.05+b0.w[uc+0][vc+0]/100;
  if (key=='W') ws=-0.05-b0.w[uc+0][vc+0]/100;
  
  b0.w[uc+0][vc+0]+=ws;
  if (b0.ud%2 != 0 && b0.vd%2 != 0)
    b0.w[uc+1][vc+1]+=ws; 
  if (b0.ud%2 != 0)
    b0.w[uc+1][vc+0]+=ws;
  if (b0.vd%2 != 0)
    b0.w[uc+0][vc+1]+=ws;
}

void mouseClicked() {
  b0 = new BezierSurface(random(2, 9), random(2, 9));
  i0 = new Interface(b0.ud, b0.vd);
}

class NBezierCurve {
  
  int n;
  ControlPoint[] P;
  PVector[] R;
  int tn;
  float[][] Bt;
  
  NBezierCurve(int degree) {
    
    n = degree;
    Bt = new float[n+1][n+1];
    P = new ControlPoint[n+1];
    
    for(int i=0; i<n+1; i++) {
      P[i]   = new ControlPoint();
      P[i].x = random(20, width-20);
      P[i].y = random(60, height-20);
    }
    
    tn = 50 + n*10;
    R = new PVector[tn];
    
    focusP = -1;
  }
  
  void draw(int mx, int my) {
    
    int tt;
    float t = 0;
    float ts = (float)1/tn;
    float B40t, B41t, B42t, B43t, B44t;
    
    stroke(0, 255, 255, 200);
    for(int i=0; i<n; i++) {
      line(P[i].x, P[i].y, P[i+1].x, P[i+1].y);
    }
    noStroke();
    
    for (int i=0; i<n+1; i++) {
      P[i].pointDraw(mx, my);
    }
    stroke(255, 255, 255);
      for (tt=0; tt<tn; tt+=1) {
      for (int i=0; i<n+1; i++) {
        Bt[n][i] = fact(n)/(fact(i)*fact(n-i)) * pow(1-t, n-i) * pow(t, i);
      }
      
      float denom = 0;
      for(int i=0; i<n+1; i++) {
        denom += P[i].weight * Bt[n][i];
      }
      
      R[tt] = new PVector();
      R[tt].x = 0;
      R[tt].y = 0;
      
      for(int i=0; i<n+1; i++)
        R[tt].x += (P[i].weight * Bt[n][i]) / denom*P[i].x;
      for(int i=0; i<n+1; i++)
        R[tt].y += (P[i].weight * Bt[n][i]) / denom * P[i].y;
      
      if (tt!=0) {
        line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);
      }
    
      t = t + ts;
    }
    line(R[tn-1].x, R[tn-1].y, P[n].x, P[n].y);
    for (int i=0; i<n+1; i++) {
      P[i].weightMode = (focusP == i) ? true : false;
    }
  }
}

class ControlPoint {
  
  float x, y, weight;
  boolean weightMode = false;
  
  ControlPoint() {
    weight = 1.0;
  }
  
  void pointDraw(int mx, int my) {
    fill(0, 255, 255, 200);
    if(isOnCursor(mx, my) || weightMode) {
      fill(255, 256, 128, 200);
    }
    if(isOnCursor(mx, my)) {
      mouseT = HAND;
    }
    if (weight > 0) {
      ellipse(x, y, weight*10, weight*10);
    }
    noFill();
  }
  
  boolean isOnCursor(int mx, int my) {
    if (mx > x-weight*5-10 && mx < x+weight*5+10) {
      if (my > y-weight*5-10 && my < y+weight*5+10) {
        return true;
      }
    }
    return false;
  }
}
  
int fact (int n) {
  int f=1;
  for (int i=1; i<n+1; i++) {
    f = f*i;
  }
  return f;
}

class GUI {
  int d = 4;
  
  void draw () {
    mouseT = ARROW;
    fill(200);
    text("n = " + d, 45, 20);
    text("press up/down arrow to change n", 45, 35);
    text("press r to refresh", 45, 50);
  }
}

NBezierCurve b0;
GUI gui;
int mouseT;
int focusP = -1;

void setup() {
  size(400, 400);
  gui = new GUI();
  b0 = new NBezierCurve(gui.d);
}

void draw() {
  background(40);
  
  gui.draw();
  b0.draw(mouseX, mouseY);
  cursor(mouseT);
}

boolean clickAction(int x, int y) {
 
  for(int i=0; i<b0.n+1; i++) {
    if(b0.P[i].isOnCursor(x, y)) {
      focusP = 1;
      return false;
    }
  }
  return true;
}

void keyPressed() {
  if(keyCode == UP) gui.d++;
  if(keyCode == DOWN && gui.d > 1) gui.d--;
  if(key == 'r') b0 = new NBezierCurve(gui.d);
}

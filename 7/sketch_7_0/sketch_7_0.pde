class BSplineCurve {
  
  int[] u;
  int n;
  int k;
  int t_max;
  float t_step;
  float[][] N;
  PVector P0, P1, P2, P3;
  PVector[] R;
  
  BSplineCurve(int _k) {
    n = 3; // 
    k = _k; //    
    
    int rs = 200;            
    R = new PVector[rs+1];   
    u = new int[n+k+1];      
    N = new float[n+k][n+2];  
    
    t_max = n-k+2;
    
    t_step = (float)t_max/rs;
    
    // Control Points
    P0 = new PVector(20, 300);
    P1 = new PVector(140, 100);
    P2 = new PVector(280, 100);
    P3 = new PVector(380, 300);
  }
  
  int knot(int j, int n, int k) {
    int uj=0;
    if      ( j < k )           { uj = 0; }
    else if ( k <= j && j <= n) { uj = j - k + 1; }
    else if ( j > n)            { uj = n - k + 2; }
    return uj;
  }
  
  void draw(color c) {  
    noFill();
    stroke(c);
    
    // knot vectors
    for ( int j=0; j<=n+k; j=j+1) u[j] = knot(j, n, k);
        
    // 0<t<t_max
    int tt = 0;
    for ( float t=0.0; t<(t_max+1e-6); t=t+t_step ) {
      int ii, kk;
    
      // k = 1
      for ( ii=0; ii<n+2; ii=ii+1 ) {
        if( u[ii] <= t && t <= u[ii+1] ) { N[ii][1] = 1; }
        else                             { N[ii][1] = 0; }

      }
      // k > 1
      float d=0, e=0;
      for ( kk=2; kk<=k ; kk=kk+1 ) {
        for ( ii=0; ii<=(n+k)-kk; ii=ii+1 ) {
          d=(u[ii+kk-1]-u[ii]!=0) ? (t - u[ii])*N[ii][kk-1]/(u[ii+kk-1]-u[ii]) 
                                  : 0;
          // if (u[ii+kk-1]-u[ii]!=0) {
          //   d = (t - u[ii])*N[ii][kk-1]/(u[ii+kk-1]-u[ii]);
          // } else {
          //   d = 0;
          // }

          e=(u[ii+kk]-u[ii+1]!=0) ? (u[ii+kk]-t)*N[ii+1][kk-1]/(u[ii+kk]-u[ii+1])
                                  : 0;
          N[ii][kk] = d + e;   
        }
      }
      
      // R(t)
      R[tt] = new PVector();
      R[tt].x =  N[0][k]*P0.x + N[1][k]*P1.x + N[2][k]*P2.x + N[3][k]*P3.x;
      R[tt].y =  N[0][k]*P0.y + N[1][k]*P1.y + N[2][k]*P2.y + N[3][k]*P3.y;

      // line
      if (tt!=0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);
          
      tt = tt + 1;
      
    }
    
  }
}

void drawControlPolygon(BSplineCurve b) {
    // control polygon  
    stroke(0, 255, 255);
    fill(0, 255, 255, 30);
    line(b.P0.x, b.P0.y, b.P1.x, b.P1.y); // p0 - p1
    line(b.P1.x, b.P1.y, b.P2.x, b.P2.y); // p1 - p2
    line(b.P2.x, b.P2.y, b.P3.x, b.P3.y); // p2 - p3
}

void drawControlPoints(BSplineCurve b) {
    // control points
    fill(0, 255, 255);
    ellipse(b.P0.x, b.P0.y, 5, 5);
    ellipse(b.P1.x, b.P1.y, 5, 5);
    ellipse(b.P2.x, b.P2.y, 5, 5);
    ellipse(b.P3.x, b.P3.y, 5, 5);
    // text control points 
    fill(255, 255, 255);
    text("P0", b.P0.x+15, b.P0.y   ); // p0
    text("P1", b.P1.x,    b.P1.y-15); // p1
    text("P2", b.P2.x+10, b.P2.y-15); // p2
    text("P3", b.P3.x-30, b.P3.y   ); // p3    
}

void drawLabel() {
  fill(255,255,255);
  text("BSplineCurve", 10, 20);
}

BSplineCurve b0, b1, b2;

void setup() {
  background(40);
  size(400, 400);
 
  b0 = new BSplineCurve(2);
  b1 = new BSplineCurve(3);
  b2 = new BSplineCurve(4);
}

void draw() {
  background(40);
  
  b0.P0.x=b1.P0.x=b2.P0.x=mouseX; 
  b0.P0.y=b1.P0.y=b2.P0.y=mouseY;
  
  drawLabel();
  drawControlPolygon(b0);
  drawControlPoints(b0);
  
  b0.draw(color(255, 0, 255));
  b1.draw(color(255, 0, 128));
  b2.draw(color(255, 0,   0));

}

int WINDOW_WIDTH=400;
int WINDOW_HEIGHT=400;

float R=50, Zo=100;
float K[]={1.0,0.0,0.0}; 
float Bg[]={0.0,0.0,0.0};

float L[]={-1,1,-1};
float dif[]={1.0,1.0,1.0};
float amb[]={0.5,0.5,0.5};

color Shading(float[] N) {
  float LN=innerProduct(L,N);
  return (LN<0)?color(255*K[0]*amb[0],
                      255*K[1]*amb[1],
                      255*K[2]*amb[2])
               :color(255*K[0]*(dif[0]*LN+amb[0]),
                      255*K[1]*(dif[1]*LN+amb[1]),
                      255*K[2]*(dif[2]*LN+amb[2]));
}

color RayTrace( float px, float py ) {
  float t=RayCast( px, py );
  if(t==-1) {
    return color(255*Bg[0],255*Bg[1],255*Bg[2]);
  } else {
    float[] N={px,py,t-Zo};
    normalize(N);
    return Shading(N);
  }
}

float RayCast( float px, float py ) {
  float d=R*R-px*px-py*py;
  float t=(d>0)?(Zo-sqrt( d )):-1;
  return t;
}

void setup() {
  background(40);
  size(400, 400);

  normalize(L);

  for( int iy=-WINDOW_HEIGHT/2; iy<WINDOW_HEIGHT/2; iy=iy+1 ) {
    for ( int ix=-WINDOW_WIDTH/2; ix<WINDOW_WIDTH/2; ix=ix+1 ) {
      set( ix+WINDOW_WIDTH/2, WINDOW_HEIGHT/2-iy, RayTrace( ix, iy ) );
    }
  }
  text("ambient light", 10, 20);
}
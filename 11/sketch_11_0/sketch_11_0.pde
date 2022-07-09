int WINDOW_WIDTH=400;
int WINDOW_HEIGHT=400;

float R=50, Zo=100;
float K[]={1.0,0.0,0.0};
float Bg[]={0.0,0.0,0.0};

color RayTrace( float px, float py ) {
  float t=RayCast( px, py );
  return (t==-1)?color(255*Bg[0],255*Bg[1],255*Bg[2]):color(255*K[0],255*K[1],255*K[2]);
}

float RayCast( float px, float py ) {
  float d=R*R - px*px - py*py;
  float t=(d>0)?(Zo-sqrt( d )):-1;
  return t;
}

void setup() {
  background(40);
  size(400, 400);

  for( int iy=-WINDOW_HEIGHT/2; iy<WINDOW_HEIGHT/2; iy=iy+1 ) {
    for ( int ix=-WINDOW_WIDTH/2; ix<WINDOW_WIDTH/2; ix=ix+1 ) {
      set( ix+WINDOW_WIDTH/2, WINDOW_HEIGHT/2-iy, RayTrace( ix, iy ) );
    }
  }
  text("super simple raytracing", 10, 20);
}

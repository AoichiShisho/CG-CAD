int WINDOW_WIDTH=400;
int WINDOW_HEIGHT=400;

float R=50, Zo=100;
float K1[]={1.0,0.0,0.0}; 
float K2[]={1.0,1.0,0.0}; 
float K3[]={0.0,1.0,0.0}; 
float K4[]={0.0,0.0,1.0}; 
float Bg[]={0.0,0.0,0.0};

float L[]={-1,1,-1};
float dif[]={1.0,1.0,1.0};
float amb[]={0.5,0.5,0.5};

color Shading1(float[] N) {
  float LN=innerProduct(L,N);
  return (LN<0)?color(255*K1[0]*amb[0],
                      255*K1[1]*amb[1],
                      255*K1[2]*amb[2])
               :color(255*K1[0]*(dif[0]*LN+amb[0]),
                      255*K1[1]*(dif[1]*LN+amb[1]),
                      255*K1[2]*(dif[2]*LN+amb[2]));
}

color Shading2(float[] N) {
  float LN=innerProduct(L,N);
  return (LN<0)?color(255*K2[0]*amb[0],
                      255*K2[1]*amb[1],
                      255*K2[2]*amb[2])
               :color(255*K2[0]*(dif[0]*LN+amb[0]),
                      255*K2[1]*(dif[1]*LN+amb[1]),
                      255*K2[2]*(dif[2]*LN+amb[2]));
}

color Shading3(float[] N) {
  float LN=innerProduct(L,N);
  return (LN<0)?color(255*K3[0]*amb[0],
                      255*K3[1]*amb[1],
                      255*K3[2]*amb[2])
               :color(255*K3[0]*(dif[0]*LN+amb[0]),
                      255*K3[1]*(dif[1]*LN+amb[1]),
                      255*K3[2]*(dif[2]*LN+amb[2]));
}

color Shading4(float[] N) {
  float LN=innerProduct(L,N);
  return (LN<0)?color(255*K4[0]*amb[0],
                      255*K4[1]*amb[1],
                      255*K4[2]*amb[2])
               :color(255*K4[0]*(dif[0]*LN+amb[0]),
                      255*K4[1]*(dif[1]*LN+amb[1]),
                      255*K4[2]*(dif[2]*LN+amb[2]));
}

color RayTrace1( float px, float py ) {
  float t=RayCast( px, py );
  if(t==-1) {
    return color(255*Bg[0],255*Bg[1],255*Bg[2]);
  } else {
    float[] N={px,py,t-Zo};
    normalize(N);
    return Shading1(N);
  }
}

color RayTrace2( float px, float py ) {
  float t=RayCast( px, py );
  if(t==-1) {
    return color(255*Bg[0],255*Bg[1],255*Bg[2]);
  } else {
    float[] N={px,py,t-Zo};
    normalize(N);
    return Shading2(N);
  }
}

color RayTrace3( float px, float py ) {
  float t=RayCast( px, py );
  if(t==-1) {
    return color(255*Bg[0],255*Bg[1],255*Bg[2]);
  } else {
    float[] N={px,py,t-Zo};
    normalize(N);
    return Shading3(N);
  }
}

color RayTrace4( float px, float py ) {
  float t=RayCast( px, py );
  if(t==-1) {
    return color(255*Bg[0],255*Bg[1],255*Bg[2]);
  } else {
    float[] N={px,py,t-Zo};
    normalize(N);
    return Shading4(N);
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

  for( int iy=-WINDOW_HEIGHT/4; iy<WINDOW_HEIGHT/4; iy=iy+1 ) {
    for ( int ix=-WINDOW_WIDTH/4; ix<WINDOW_WIDTH/4; ix=ix+1 ) {
      set( ix+WINDOW_WIDTH/4, WINDOW_HEIGHT/4-iy, RayTrace1( ix, iy ) );
    }
  }
  for( int iy=-WINDOW_HEIGHT/4; iy<WINDOW_HEIGHT/4; iy=iy+1 ) {
    for ( int ix=-WINDOW_WIDTH/4; ix<WINDOW_WIDTH/4; ix=ix+1 ) {
      set( ix+WINDOW_WIDTH*3/4, WINDOW_HEIGHT*3/4-iy, RayTrace2( ix, iy ) );
    }
  }
  for( int iy=-WINDOW_HEIGHT/4; iy<WINDOW_HEIGHT/4; iy=iy+1 ) {
    for ( int ix=-WINDOW_WIDTH/4; ix<WINDOW_WIDTH/4; ix=ix+1 ) {
      set( ix+WINDOW_WIDTH*3/4, WINDOW_HEIGHT/4-iy, RayTrace3( ix, iy ) );
    }
  }
  for( int iy=-WINDOW_HEIGHT/4; iy<WINDOW_HEIGHT/4; iy=iy+1 ) {
    for ( int ix=-WINDOW_WIDTH/4; ix<WINDOW_WIDTH/4; ix=ix+1 ) {
      set( ix+WINDOW_WIDTH/4, WINDOW_HEIGHT*3/4-iy, RayTrace4( ix, iy ) );
    }
  }
  text("ambient lights", 10, 20);
}

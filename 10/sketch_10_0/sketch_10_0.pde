int WINDOW_WIDTH  = 400;
int WINDOW_HEIGHT = 400;
float HALF_WIDTH = WINDOW_WIDTH *0.5;
float HALF_HEIGHT= WINDOW_HEIGHT*0.5;

float screen_x = 3;
float screen_y = 3;

int[][][] image_out;

// matrix for affine transformation
float M[][] = { {1, 0, 0, 0},
                {0, 1, 0, 0},
                {0, 0, 1, 0},
                {0, 0, 0, 1}  };

Triangle T0;

void clear() {
  for(int j=0; j<WINDOW_HEIGHT; j++) {
    for(int i=0; i<WINDOW_WIDTH; i++) {
      image_out[0][j][i]=0;
      image_out[1][j][i]=0;
      image_out[2][j][i]=0;
    }
  }
}

void display() {
  for(int i=0; i<WINDOW_HEIGHT; i++) {
    for(int j=0; j<WINDOW_WIDTH; j++) {
      set(j, i, color(image_out[0][i][j], image_out[1][i][j], image_out[2][i][j]));
    }
  }
}

void setup() {
  size(400, 400);
  image_out = new int[3][WINDOW_HEIGHT][WINDOW_WIDTH];
  clear();
  
  T0 = new Triangle(  0,  2, 0, 
                     -2, -2, 0, 
                      2, -2, 0  );
  
}

float t=0.0; float ts=0.01;
float r=0.0; float rs=0.02;
float s=1;   float ss=0.01;
void draw() {
  clear();
  
  // Translate
  t+=ts;
  if(t>screen_x || t<-screen_x) ts=-ts;
  init_matrix(M);
  matrix_translate(M, t, 0, 0);
  T0.draw(color(255,0,0));
  
  // Rotate
  r+=rs;
  if(r>TWO_PI) r=0.0;
  init_matrix(M);
  matrix_rotate(M, 'Y', r);
  T0.draw(color(0,255,0));
  
  // Scale
  s+=ss;
  if(s>1 || s<0.5) ss=-ss;
  init_matrix(M);
  matrix_scale(M, s, s, s);
  T0.draw(color(0,0,255));
  
  // draw everything.
  display();
}
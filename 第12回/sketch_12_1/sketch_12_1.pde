int WINDOW_WIDTH  = 400;
int WINDOW_HEIGHT = 400;
float HALF_WIDTH = WINDOW_WIDTH *0.5;
float HALF_HEIGHT= WINDOW_HEIGHT*0.5;

float screen_x = 3;
float screen_y = 3;

int[][][] image_out;
float[][] z_buffer; // Zバッファ
boolean use_z_buffer=false;

// matrix for affine transformation
float M[][] = { {1, 0, 0, 0},
                {0, 1, 0, 0},
                {0, 0, 1, 0},
                {0, 0, 0, 1}  };

Tetrahedron Tt0;

void clear() {
  for(int j=0; j<WINDOW_HEIGHT; j++) {
    for(int i=0; i<WINDOW_WIDTH; i++) {
      image_out[0][j][i]=0;
      image_out[1][j][i]=0;
      image_out[2][j][i]=0;

      z_buffer[j][i]= Float.NEGATIVE_INFINITY;
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
  z_buffer  = new float[WINDOW_HEIGHT][WINDOW_WIDTH]; // Zバッファのメモリを確保します。

  clear();
  
  Tt0 = new Tetrahedron();  

}


float r=0.0; float rs=0.02;

void draw() {

  clear();

  // Rotate
  r+=rs;
  if(r>TWO_PI) r=0.0;
  init_matrix(M);
  matrix_rotate(M, 'Y', r);
  Tt0.draw();
    
  // draw everything.
  display();

  stroke(255, 255, 255);
  text("Z Buffer Algorithm", 10, 20);
}

void keyPressed() {
  if( key=='z') use_z_buffer=true;
}

void keyReleased() {
  if( key=='z') use_z_buffer=false;
}

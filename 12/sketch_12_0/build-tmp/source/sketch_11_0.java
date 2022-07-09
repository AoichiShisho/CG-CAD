import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_11_0 extends PApplet {

int WINDOW_WIDTH  = 400;
int WINDOW_HEIGHT = 400;
float HALF_WIDTH = WINDOW_WIDTH *0.5f;
float HALF_HEIGHT= WINDOW_HEIGHT*0.5f;

float screen_x = 3;
float screen_y = 3;

int[][][] image_out;

// matrix for affine transformation
float M[][] = { {1, 0, 0, 0},
                {0, 1, 0, 0},
                {0, 0, 1, 0},
                {0, 0, 0, 1}  };

Tetrahedron Tt0;

public void clear() {
  for(int j=0; j<WINDOW_HEIGHT; j++) {
    for(int i=0; i<WINDOW_WIDTH; i++) {
      image_out[0][j][i]=0;
      image_out[1][j][i]=0;
      image_out[2][j][i]=0;


    }
  }
}

public void display() {
  for(int i=0; i<WINDOW_HEIGHT; i++) {
    for(int j=0; j<WINDOW_WIDTH; j++) {
      set(j, i, color(image_out[0][i][j], image_out[1][i][j], image_out[2][i][j]));
    }
  }
}

public void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  image_out = new int[3][WINDOW_HEIGHT][WINDOW_WIDTH];


  clear();
  
  Tt0 = new Tetrahedron();  

}


float r=0.0f; float rs=0.02f;

public void draw() {

  clear();

  // Rotate
  r+=rs;
  if(r>TWO_PI) r=0.0f;
  init_matrix(M);
  matrix_rotate(M, 'Y', r);
  Tt0.draw();
    
  // draw everything.
  display();

  stroke(255, 255, 255);
  text("Tetrahedron", 10, 20);
}




class Tetrahedron {
    /////////////////////////////////////////////////////////////////////////////////////
    //  Property
    /////////////////////////////////////////////////////////////////////////////////////	
	float[] P0;
	float[] P1;
	float[] P2;
	float[] P3;

	Triangle T0;
	Triangle T1;
	Triangle T2;
	Triangle T3;

    /////////////////////////////////////////////////////////////////////////////////////
    //  Constructor
    /////////////////////////////////////////////////////////////////////////////////////	
	Tetrahedron() {
		P0=new float[3]; P0[0]=-1; P0[1]=-1; P0[2]=-1;
		P1=new float[3]; P1[0]=-1; P1[1]= 1; P1[2]= 1;
		P2=new float[3]; P2[0]= 1; P2[1]=-1; P2[2]= 1;
		P3=new float[3]; P3[0]= 1; P3[1]= 1; P3[2]=-1;

		T0=new Triangle(P0,P3,P2);
		T1=new Triangle(P0,P2,P1);
		T2=new Triangle(P0,P1,P3);
		T3=new Triangle(P1,P2,P3);
	}

    /////////////////////////////////////////////////////////////////////////////////////
    //  Method
    /////////////////////////////////////////////////////////////////////////////////////	
	public void draw() {
		T0.draw(0,200,200);
		T1.draw(200,0,200);
		T2.draw(200,200,0);
		T3.draw(0,0,200);
	}

}
class Triangle {
  float[] V0;
  float[] V1;
  float[] V2;

  Triangle(float ax, float ay, float az, float bx, float by, float bz, float cx, float cy, float cz) {
    V0=new float[3]; V0[0]=ax; V0[1]=ay; V0[2]=az;
    V1=new float[3]; V1[0]=bx; V1[1]=by; V1[2]=bz;
    V2=new float[3]; V2[0]=cx; V2[1]=cy; V2[2]=cz;
  }
  
  Triangle(PVector a, PVector b, PVector c) {
    this(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z);
  }
  
  Triangle(float[] a, float[] b, float[] c) {
    this(a[0], a[1], a[2], b[0], b[1], b[2], c[0], c[1], c[2]);
  }
  
  public void draw(int c) {
    draw((int)red(c), (int)green(c), (int)blue(c));
  }
  
  public void draw(int R, int G, int B) {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  homogeneous coordinate
    /////////////////////////////////////////////////////////////////////////////////////
    float[] P0={V0[0],V0[1],V0[2],1.0f};   // V0
    float[] P1={V1[0],V1[1],V1[2],1.0f};   // V1
    float[] P2={V2[0],V2[1],V2[2],1.0f};   // V2

    /////////////////////////////////////////////////////////////////////////////////////
    //  Z Buffer
    /////////////////////////////////////////////////////////////////////////////////////
    
  
    /////////////////////////////////////////////////////////////////////////////////////
    //  affine transformation
    /////////////////////////////////////////////////////////////////////////////////////
    float[] Q0={0,0,0,0};  mult(P0, M, Q0); // V0
    float[] Q1={0,0,0,0};  mult(P1, M, Q1); // V1
    float[] Q2={0,0,0,0};  mult(P2, M, Q2); // V2
  
    /////////////////////////////////////////////////////////////////////////////////////
    // Global -> Window coordinate
    // note that (0,0,0) is the center of the window.
    /////////////////////////////////////////////////////////////////////////////////////
    float[] W0={0,0}; float[] W1={0,0}; float[] W2={0,0};  
    // multiply half_width and half_height
    W0[0]=(float)(Q0[0]/screen_x)*HALF_WIDTH; W0[1]=(float)(Q0[1]/screen_y)*HALF_HEIGHT; // V0
    W1[0]=(float)(Q1[0]/screen_x)*HALF_WIDTH; W1[1]=(float)(Q1[1]/screen_y)*HALF_HEIGHT; // V1
    W2[0]=(float)(Q2[0]/screen_x)*HALF_WIDTH; W2[1]=(float)(Q2[1]/screen_y)*HALF_HEIGHT; // V2
    // move to center;
    W0[0]=W0[0]+HALF_WIDTH; W0[1]=HALF_HEIGHT-W0[1];
    W1[0]=W1[0]+HALF_WIDTH; W1[1]=HALF_HEIGHT-W1[1];
    W2[0]=W2[0]+HALF_WIDTH; W2[1]=HALF_HEIGHT-W2[1];

    // Z Buffer
    
        
    /////////////////////////////////////////////////////////////////////////////////////
    // Paint inside the triangle composed of W0, W1, and W2.
    /////////////////////////////////////////////////////////////////////////////////////
    // Differences between W0, W1, and W2.  
    int[] dx={0,0,0}; int[] dy={0,0,0}; float[] dz={0,0,0};
    dx[0]=PApplet.parseInt(W1[0]-W0[0]); dy[0]=PApplet.parseInt(W1[1]-W0[1]); 
    dx[1]=PApplet.parseInt(W2[0]-W1[0]); dy[1]=PApplet.parseInt(W2[1]-W1[1]); 
    dx[2]=PApplet.parseInt(W0[0]-W2[0]); dy[2]=PApplet.parseInt(W0[1]-W2[1]); 

    // Which is the y min value among W0[0], W1[0], and W2[0].
    int ymin = (int)W0[1]; if(ymin>W0[1]){ymin=(int)W0[1];} if(ymin>W1[1]){ymin=(int)W1[1];} if(ymin>W2[1]){ymin=(int)W2[1];}
    // Which is the y max value among W0[0], W1[0], and W2[0].
    int ymax = (int)W0[1]; if(ymax<W0[1]){ymax=(int)W0[1];} if(ymax<W1[1]){ymax=(int)W1[1];} if(ymax<W2[1]){ymax=(int)W2[1];}
    // scaning from ymin to ymax  
    for (int iy=ymin; iy<=ymax; iy++) {
      // draw if iy is more than > 0 or iy is less than <= WINDOW_HEIGHT,
      // which means draw if iy is in the window.
      if(iy<0 || iy>=WINDOW_HEIGHT) continue;
      
      /////////////////////////////////////////////////////////////////////////////////////
      // Find xs and xe at parameter iy
      // xs and xe are the min or max value respectively among x coordinates of the triangle.
      /////////////////////////////////////////////////////////////////////////////////////
      float t;
      int xt=0;  
      int xs=Integer.MAX_VALUE, xe=Integer.MIN_VALUE;


      
      // W1-W0
      if(dy[0]!=0) {
        t=(iy-W0[1])/dy[0];
        if(t>=0.0f&&t<=1.0f) {
          xt=(int)(W0[0]+dx[0]*t);

          if(xt<=xs) { xs=xt;        }
          if(xt>=xe) { xe=xt;        }
        }
      }
      
      // W2-W1
      if(dy[1]!=0) {
        t=(iy-W1[1])/(float)dy[1];
        if(t>0.0f&&t<=1.0f) {
          xt=(int)(W1[0]+dx[1]*t);

          if(xt<=xs) { xs=xt;        }
          if(xt>=xe) { xe=xt;        }
        }
      }
      
      // W0-W2
      if(dy[2]!=0) {
        t=(iy-W2[1])/(float)dy[2];
        if(t>=0.0f&&t<=1.0f) {
          xt=(int)(W2[0]+dx[2]*t);

          if(xt<=xs) { xs=xt;        }
          if(xt>=xe) { xe=xt;        }
        }
      }    
      
      // paint from pixel(xs,iy) to pixel(xe,iy)
      for (int ix=xs ; ix<=xe; ix++) {
        // draw if iy is more than > 0 or ix is less than <= WINDOW_WIDTH,
        // which means draw if iy is in the window.      
        if(ix<0||ix>=WINDOW_WIDTH) continue; 

 





        //
        if(ix==xs||ix==xe) {
          image_out[0][iy][ix]=image_out[1][iy][ix]=image_out[2][iy][ix]=255;
        } else {
          image_out[0][iy][ix]=R; // R
          image_out[1][iy][ix]=G; // G
          image_out[2][iy][ix]=B; // B
        }          

      } 
    }
    
  }  
}
///////////////////////////////////////////////////////////////////////////////////
// Affine Transformation
///////////////////////////////////////////////////////////////////////////////////
// unit matrix
public void init_matrix(float[][] M) {
  M[0][0]=1; M[0][1]=0; M[0][2]=0; M[0][3]=0;
  M[1][0]=0; M[1][1]=1; M[1][2]=0; M[1][3]=0;
  M[2][0]=0; M[2][1]=0; M[2][2]=1; M[2][3]=0;
  M[3][0]=0; M[3][1]=0; M[3][2]=0; M[3][3]=1;
}

// translation
public void matrix_translate(float[][] M, float x, float y, float z) {
  init_matrix(M);
  M[3][0]=x; M[3][1]=y; M[3][2]=z;
}

// rotation
public void matrix_rotate(float[][] M, char axis, float theta) {
  init_matrix(M);
  if( axis=='x'||axis=='X' ) {
    M[1][1]= cos(theta);
    M[1][2]= sin(theta);
    M[2][1]=-sin(theta);
    M[2][2]= cos(theta);
  } else if( axis=='y'||axis=='Y' ) {
    M[2][2]= cos(theta);
    M[2][0]= sin(theta);
    M[0][2]=-sin(theta);
    M[0][0]= cos(theta);
  } else if( axis=='z'||axis=='Z' ) {
    M[0][0]= cos(theta);
    M[0][1]= sin(theta);
    M[1][0]=-sin(theta);
    M[1][1]= cos(theta);
  }
}

// scale
public void matrix_scale(float[][] M, float x, float y, float z) {
  init_matrix(M);
  M[0][0]=x; M[1][1]=y; M[2][2]=z;
}

// vector Vinput x matrix M = vector Voutput
public void mult(float[] Vi, float[][]M, float[]Vo) {
  Vo[0]=Vi[0]*M[0][0]+Vi[1]*M[1][0]+Vi[2]*M[2][0]+Vi[3]*M[3][0];
  Vo[1]=Vi[0]*M[0][1]+Vi[1]*M[1][1]+Vi[2]*M[2][1]+Vi[3]*M[3][1];
  Vo[2]=Vi[0]*M[0][2]+Vi[1]*M[1][2]+Vi[2]*M[2][2]+Vi[3]*M[3][2];
  Vo[3]=Vi[0]*M[0][3]+Vi[1]*M[1][3]+Vi[2]*M[2][3]+Vi[3]*M[3][3];
}

// matrix Ma x matrix Mb = matrix Moutput
public void mult(float[][] Ma, float[][]Mb, float[][] Mo) {
  Mo[0][0]=Ma[0][0]*Mb[0][0]+Ma[0][1]*Mb[1][0]+Ma[0][2]*Mb[2][0]+Ma[0][3]*Mb[3][0];
  Mo[0][1]=Ma[0][0]*Mb[0][1]+Ma[0][1]*Mb[1][1]+Ma[0][2]*Mb[2][1]+Ma[0][3]*Mb[3][1];
  Mo[0][2]=Ma[0][0]*Mb[0][2]+Ma[0][1]*Mb[1][2]+Ma[0][2]*Mb[2][2]+Ma[0][3]*Mb[3][2];
  Mo[0][3]=Ma[0][0]*Mb[0][3]+Ma[0][1]*Mb[1][3]+Ma[0][2]*Mb[2][3]+Ma[0][3]*Mb[3][3];
  Mo[1][0]=Ma[1][0]*Mb[0][0]+Ma[1][1]*Mb[1][0]+Ma[1][2]*Mb[2][0]+Ma[1][3]*Mb[3][0];
  Mo[1][1]=Ma[1][0]*Mb[0][1]+Ma[1][1]*Mb[1][1]+Ma[1][2]*Mb[2][1]+Ma[1][3]*Mb[3][1];
  Mo[1][2]=Ma[1][0]*Mb[0][2]+Ma[1][1]*Mb[1][2]+Ma[1][2]*Mb[2][2]+Ma[1][3]*Mb[3][2];
  Mo[1][3]=Ma[1][0]*Mb[0][3]+Ma[1][1]*Mb[1][3]+Ma[1][2]*Mb[2][3]+Ma[1][3]*Mb[3][3];
  Mo[2][0]=Ma[2][0]*Mb[0][0]+Ma[2][1]*Mb[1][0]+Ma[2][2]*Mb[2][0]+Ma[2][3]*Mb[3][0];
  Mo[2][1]=Ma[2][0]*Mb[0][1]+Ma[2][1]*Mb[1][1]+Ma[2][2]*Mb[2][1]+Ma[2][3]*Mb[3][1];
  Mo[2][2]=Ma[2][0]*Mb[0][2]+Ma[2][1]*Mb[1][2]+Ma[2][2]*Mb[2][2]+Ma[2][3]*Mb[3][2];
  Mo[2][3]=Ma[2][0]*Mb[0][3]+Ma[2][1]*Mb[1][3]+Ma[2][2]*Mb[2][3]+Ma[2][3]*Mb[3][3];
  Mo[3][0]=Ma[3][0]*Mb[0][0]+Ma[3][1]*Mb[1][0]+Ma[3][2]*Mb[2][0]+Ma[3][3]*Mb[3][0];
  Mo[3][1]=Ma[3][0]*Mb[0][1]+Ma[3][1]*Mb[1][1]+Ma[3][2]*Mb[2][1]+Ma[3][3]*Mb[3][1];
  Mo[3][2]=Ma[3][0]*Mb[0][2]+Ma[3][1]*Mb[1][2]+Ma[3][2]*Mb[2][2]+Ma[3][3]*Mb[3][2];
  Mo[3][3]=Ma[3][0]*Mb[0][3]+Ma[3][1]*Mb[1][3]+Ma[3][2]*Mb[2][3]+Ma[3][3]*Mb[3][3];
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_11_0" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

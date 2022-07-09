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
  
  void draw(color c) {
    draw((int)red(c), (int)green(c), (int)blue(c));
  }
  
  void draw(int R, int G, int B) {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  homogeneous coordinate
    /////////////////////////////////////////////////////////////////////////////////////
    float[] P0={V0[0],V0[1],V0[2],1.0};   // V0
    float[] P1={V1[0],V1[1],V1[2],1.0};   // V1
    float[] P2={V2[0],V2[1],V2[2],1.0};   // V2

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
    dx[0]=int(W1[0]-W0[0]); dy[0]=int(W1[1]-W0[1]); 
    dx[1]=int(W2[0]-W1[0]); dy[1]=int(W2[1]-W1[1]); 
    dx[2]=int(W0[0]-W2[0]); dy[2]=int(W0[1]-W2[1]); 

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
        if(t>=0.0&&t<=1.0) {
          xt=(int)(W0[0]+dx[0]*t);

          if(xt<=xs) { xs=xt;        }
          if(xt>=xe) { xe=xt;        }
        }
      }
      
      // W2-W1
      if(dy[1]!=0) {
        t=(iy-W1[1])/(float)dy[1];
        if(t>0.0&&t<=1.0) {
          xt=(int)(W1[0]+dx[1]*t);

          if(xt<=xs) { xs=xt;        }
          if(xt>=xe) { xe=xt;        }
        }
      }
      
      // W0-W2
      if(dy[2]!=0) {
        t=(iy-W2[1])/(float)dy[2];
        if(t>=0.0&&t<=1.0) {
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

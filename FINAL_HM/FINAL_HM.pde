PShape art; 
int point = 5;
void setup(){
  size(500, 500, P2D);
  colorMode(HSB, 1);
  background(0, 0, 0);
  makeCurve();  
  drawShape();  
}

void drawShape(){
  for (int w=1; w<5; w++) {
    for (int h=1; h<5; h++) {
      translate(width/random(10, 20) * w, height/random(10, 20) * h);
        for(int j=0; j<3; j++){
          for(int k=0; k<point; k++){
            pushMatrix();
            scale(1, pow(-1, j));
            rotate(k*2*PI / point);
            shape(art);
            popMatrix();
          }
        }
      }
  }
}

void makeCurve(){
  PVector[] v = new PVector[2];
  for(int i=0; i<2; i++){
    v[i] = PVector.fromAngle(i*PI / point); 
    v[i].mult(width/4);
  }
  PVector[] ctr = new PVector[4];
  for (int i=0; i<4; i++){
    ctr[i] = PVector.mult(v[i/2], random(1));
  }
  art = createShape();
  art.setFill(color(random(1), random(0.25, 0.75), 1));
  art.beginShape();
  art.vertex(0, 0);
  art.vertex(ctr[0].x, ctr[0].y);
  art.bezierVertex(ctr[1].x, ctr[1].y, ctr[2].x, ctr[2].y, ctr[3].x, ctr[3].y);
  art.endShape(CLOSE);
}

void mouseClicked() {
    background(0);
    makeCurve();
    drawShape();
}

void draw(){}

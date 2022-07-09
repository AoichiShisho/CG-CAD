PShape art; 
int point = 10;
void setup(){
  size(500, 500, P2D);
  colorMode(HSB, 1);
  background(0, 0, 1);
  makeCurve(); 
  drawShape();
}

void drawShape(){
  translate(width/2, height/2);
  for(int j=0; j<2; j++){
    for(int k=0; k<point; k++){
      pushMatrix();
      scale(1, pow(-1, j));
      rotate(k*2*PI / point);
      shape(art);
      popMatrix();
    }
  }
}

void makeCurve(){
  PVector[] v = new PVector[2];
  for(int i=0; i<2; i++){
    v[i] = PVector.fromAngle(i*PI/ point);
    v[i].mult(width/2);
  }
  PVector[] ctr = new PVector[4];
  for (int i=0; i<4; i++){
    ctr[i] = PVector.mult(v[i/2], random(1));
  }
  art = createShape();
  art.setFill(color(random(1), 1, 1));
  art.beginShape();
  art.vertex(0, 0);
  art.vertex(ctr[0].x, ctr[0].y);
  art.bezierVertex(ctr[1].x, ctr[1].y, ctr[2].x, ctr[2].y, ctr[3].x, ctr[3].y);
  art.endShape(CLOSE);
}

void mouseClicked() {
    makeCurve();
    drawShape();
}

void draw(){
}


PVector p0, p1, p2, p3;

void setup() {
  size(400, 400);
  p0 = new PVector(20, 300);
  p1 = new PVector(140, 100);
  p2 = new PVector(280, 100);
  p3 = new PVector(380, 300);
}

void draw() {
  background(40);
  
  p0.x = mouseX;  p0.y = mouseY;
  
  // line
  stroke(0, 255, 255);
  fill(0, 255, 255, 30);
  quad(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);  
  line(p0.x, p0.y, p1.x, p1.y); // p0 - p1
  line(p1.x, p1.y, p2.x, p2.y); // p1 - p2
  line(p2.x, p2.y, p3.x, p3.y); // p2 - p3

  // draw control points
  fill(0, 255, 255);
  ellipse(p0.x, p0.y, 10, 10);  // p0
  ellipse(p1.x, p1.y, 10, 10);  // p1
  ellipse(p2.x, p2.y, 10, 10);  // p2
  ellipse(p3.x, p3.y, 10, 10);  // p3
  
  // text control points 
  fill(255, 255, 255);
  text("P0", p0.x+15, p0.y   ); // p0
  text("P1", p1.x,    p1.y-15); // p1
  text("P2", p2.x+10, p2.y-15); // p2
  text("P3", p3.x-30, p3.y   ); // p3
  
  // draw bezier curve
  noFill();    
  stroke(255, 255, 255);
  bezier(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);  
  
  text("bezier", 10, 20);
  
}

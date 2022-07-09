void setup() {
  size(1000, 600);
  background(0);
}
int x1 = 50, y1 = 200;
int x2 = 450, y2 = 500;
int x3 = 850, y3 = 350;
float t = 0;

void draw() {
  fill(255);
  textSize(20);
  text("Slither.io Hommage", 20, 20);
  text("Move blue ball to change bezier", 20, 40);
  text("Press r to reset canvas", 20, 60);
  
  t += 0.005;
  float X1 = (x2-x1)*t + x1;
  float Y1 = (y2-y1)*t + y1;
  float X2 = (x3-x2)*t + x2;
  float Y2 = (y3-y2)*t + y2;
  
  fill(255, 0, 0);
  if (t > 1) t = 0;
  ellipse((X2-X1)*t+X1, (Y2-Y1)*t+Y1, 50, 50);
  ellipse(x1, y1, 50, 50);
  
  if (dist(x1, y1, mouseX, mouseY) < 60 && mousePressed) {
    x1 = mouseX;
    y1 = mouseY;
  }
  else if (dist(x2, y2, mouseX, mouseY) < 60 && mousePressed) {
    x2 = mouseX;
    y2 = mouseY;
  }
  else if (dist(x3, y3, mouseX, mouseY) < 60 && mousePressed) {
    x3 = mouseX;
    y3 = mouseY;
  }
  
  ellipse(x3, y3, 50, 50);
  
  fill(0, 0, 255);
  ellipse(x2, y2, 25, 25);
  
  fill(255);
  ellipse(x3-10, y3-3, 20, 20);
  ellipse(x3+10, y3-7, 20, 20);
  fill(0);
  ellipse(x3-7, y3-3, 10, 10);
  ellipse(x3+13, y3-7, 10, 10);
}

void keyReleased() {
  if (key == 'r') {
    background(0);
  }
}

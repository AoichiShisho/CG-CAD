class CVertex {
  int x;
  int y;
  
  CVertex() { 
    x=0; 
    y=0;
  } 
  
  void draw() {
    set(x, y, color(255));
  }
}

CVertex v0, v1;

void setup() {
  size(400, 400);
  textSize(16);

  v0 = new CVertex(); 
  v1 = new CVertex(); 
  v0.x = 200; 
  v0.y = 200;
  v1.x = 200; 
  v1.y = 200;
}

void draw() {
  background(40);

  v1.x = mouseX;
  v1.y = mouseY;

  int dx = v1.x - v0.x;
  int dy = v1.y - v0.y;
  int x, y;

  x = v0.x;
  y = v0.y;

  if (abs(dx) >= abs(dy)) {
    int z = -dx;

    if (dx>=0) {
      if (dy<=0) {
        for (; x<v1.x; x++ ) {
          set(x, y, color(255));
          z = z-2*dy;

          if (z>=0) {
            y--;
            z = z-2*dx;
          }
        }
      } 
      else {
          for (; x<v1.x; x++ ) {
          set(x, y, color(255));
          z = z+2*dy;

          if (z>=0) {
            y++;
            z = z-2*dx;
          }
        }
      }
    } 
    else {
      if (dy>=0) {
        for (; x>v1.x; x--) {
          set(x, y, color(255));
          z = z-2*dy;

          if (z<=0) {
            y++;
            z = z-2*dx;
          }
        }
      } 
      else {
          for (; x>v1.x; x--) {
          set(x, y, color(255));
          z = z+2*dy;

          if (z<=0) {
            y--;
            z = z-2*dx;
          }
        }
      }
    }
  } 
  else {
    int z = -dy;

    if (dy>=0) {
      if (dx>=0) {
        for (; y<v1.y; y++) {
          set(x, y, color(255));
          z = z+2*dx;

          if (z>=0) {
            x++;
            z = z-2*dy;
          }
        }
      } 
      else {
          for (; y<v1.y; y++) {
          set(x, y, color(255));
          z = z-2*dx;

          if (z>=0) {
            x--;
            z = z-2*dy;
          }
        }
      }
    } else {
      if (dx<=0) {
        for (; y>v1.y; y--) {
          set(x, y, color(255));
          z = z-2*dx;

          if (z>=0) {
            x--;
            z = z+2*dy;
          }
        }
      } 
      else {
          for (; y>v1.y; y--) {
          set(x, y, color(255));
          z = z+2*dx;

          if (z>=0) {
            x++;
            z = z+2*dy;
          }
        }
      }
    }
  }
  v0.draw();
  v1.draw();
}

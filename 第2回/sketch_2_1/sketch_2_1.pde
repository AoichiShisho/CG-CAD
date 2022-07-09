// Vertex Class
class CVertex {
  int x;
  int y;
  CVertex() { x=0; y=0; } 
  void draw() {
    set(x, y, color(255));
  }
}

CVertex v0;
CVertex v1;

void setup() {
  size(400, 400);
  background(40); 
  v0=new CVertex(); v0.x=10;  v0.y=10;
  v1=new CVertex(); v1.x=222; v1.y=100;
}

void draw() {
      background(40);
      int dx = v1.x - v0.x; // Δx の計算
      int dy = v1.y - v0.y; // Δyの計算
      // float e = 0.0; // e1
      int E = -dx;
      int x, y; // 塗りつぶすピクセル．両方とも整数(int)になっている．

      x = v0.x;  // 始点
      y = v0.y;

      // 始点から終点まで稜線を描く
      for( ; x <= v1.x; x = x+1 ) {
            set(x, y, color(255));
            // e = e + (float)dy/dx; // e に dy/dx を蓄積していく．
            E = E + 2 * dy;

            // if( e >= 0.5 ) {
            if (E >= 0) {
                  y = y + 1;
                  // e = e - 1;
                  E = E - 2 * dx;
            }
      }
}










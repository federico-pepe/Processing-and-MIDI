class Circle {
  int x;
  int y;
  color c = 255;
  float numLines = 0;
  float radius = width/3;

  Circle(int _x, int _y) {
    this.x = _x;
    this.y = _y;
  }

  void display() {
    if(numLines  > 100) {
      numLines = 0;
    }
    stroke(this.c);
    //translate(width/2, height/2);
    
    for (int i=0; i< numLines; i++) {
      float y = -radius + (i*2*radius)/numLines;
      float x = sqrt(sq(radius) - sq(y));
      line(-x, y, x, y);
    }
  }

  void changeC(color _c) {
    this.c = _c;
  }
}

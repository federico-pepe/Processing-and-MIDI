class Drum {
  
  int x;
  int y;
  int diameter = 50;
  
  color c;
  color targetColor;
  
  Drum(int x, int y, color c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }
  
  void display() {
    fill(c);
    noStroke();
    ellipse(this.x, this.y, diameter, diameter);
  }
  
  void animate() {
    
    Ani.to(this, 0.25, "y", height/2 - 50, Ani.SINE_OUT);
    
  }
  
  void reset() {
    Ani.to(this, 0.25, "y", height/2, Ani.LINEAR);
  }

}

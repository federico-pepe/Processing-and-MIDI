class Drum {
  
  int x;
  int y;
  int diameter = 50;
  
  /*** COLORS ***/
  color c;
  float hue;
  float sat;
  float bri;
  
  
  Drum(int x, int y, color c) {
    this.x = x;
    this.y = y;
    this.c = c;
    
    hue = hue(this.c);
    sat = saturation(this.c);
    bri = brightness(this.c);
  }
  
  void display() {
    fill(c);
    ellipse(this.x, this.y, diameter, diameter);
  }
  
  void animate() {
    float newBri = 255;
    c = color(hue, sat, newBri);
    Ani.to(this, 0.25, "y", height/2 - 50, Ani.SINE_OUT);
    
  }
  
  void reset() {
    c = color(hue, sat, bri);
    Ani.to(this, 0.25, "y", height/2, Ani.LINEAR);
  }

}

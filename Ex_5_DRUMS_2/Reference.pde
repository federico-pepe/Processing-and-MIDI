class Reference {
  int x;
  Reference(int _x) {
    x = _x;
  }
  
  void display() {
    stroke(127);
    line(x, height/3, x, height / 3 * 2);
  }
  
  void flash() {
    stroke(255);
    line(x, height / 4, x, height - height / 4);
    stroke(127);
  }  
}

class Piano {
  
  float xPos;
  float rectWidth;
  int colorFill;
  
  Piano(float tempXPos, float tempRectWidth, int tempColorFill) {
    xPos = tempXPos;
    rectWidth = tempRectWidth;
    colorFill = tempColorFill;
  }
  
  void display() {
    fill(colorFill);
    rect(xPos, 0, rectWidth, height);
  }
  
  void fade() {
    colorFill--;
  }
  
  boolean isEnd(Piano p) {
    if(p.colorFill <= 0) {
      return true;
    } else {
      return false;
    }
  }
  
}
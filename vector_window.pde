class Vector_window {
  int x;
  int y;
  int win_width;
  int win_height;
  int x_center;
  int y_center;
  
  IntList headings; 
  
  Vector_window(int _x, int _y, int _width, int _height) {
    x = _x;
    y = _y;
    win_width = _width;
    win_height =_height; 
    x_center = (win_width - x) / 2;
    y_center = (win_height - y) /2;
    
    headings = new IntList();
  }
  
  void add_heading(int h) { headings.add(h); }
  
  void display() {
    fill(0);
    rectMode(CENTER);
    rect(x_center, y_center, 20, 20); 
  }
};

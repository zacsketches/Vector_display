/*
  I need to add a point list for the tips of all the heading vectors.  
  
  I want a thin red line from the origin point in the direction of each
  heading to serve as a small unit vector that indicates the direction
  of each heading in the scan.
  
  Then under each unit vector will be a thicker black vector in the direction
  of any detected obstruction.
*/

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
  
  void add_heading(int h) { 
    headings.append(h-90); 
    println(cos(to_radians(-90)));
  }
  
  void display() {
    fill(0);
    rectMode(CENTER);
    rect(x_center, y_center, 20, 20); 
  }
  
  float to_radians(int h) {
    return float(h) * PI / 180; 
  }
};

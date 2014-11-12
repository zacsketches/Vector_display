class Text_window {
  int x_orig;
  int y_orig;
  int w;
  int h;
  
  color border_color = color(25);
  color fill_color = color(240);
  color text_color = color(0);
  int text_offset = 10;
  
  String data;
  
  Text_window(int _x, int _y, int _w, int _h) {
    x_orig = _x;
    y_orig = _y;
    w = _w;
    h = _h;
  
    data = "No data";  
  }
  
  void update(String new_data) { data = new_data; }
  void display() {
    rectMode(CORNER);
    stroke(border_color);
    fill(fill_color);
 
    rect( x_orig, y_orig, width-1, height-y_orig-1);
    textAlign(LEFT);
    
    //find the height in the center of the text box
    //TODO: could offset for the height of the font, but this is
    //good enough for now.
    int text_y = ((height - y_orig) / 2) + y_orig + text_size/2;
    int text_x = x_orig + text_offset;
    fill(text_color);
    text(data, text_x, text_y);
  
  }
};

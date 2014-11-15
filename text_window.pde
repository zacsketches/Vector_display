//************************************************************************
//*                         TEXT WINDOW
//************************************************************************
class Text_window {
  int x_orig;
  int y_orig;
  int w;
  int h;
  
  PFont my_font;
  int text_size = 10;
  color text_color = color(0);
  
  
  color border_color = color(25);
  color fill_color = color(240);
  int stroke_weight = 2;
  int text_offset = 10;
    
  String data;
  
  Text_window(int _x, int _y, int _w, int _h) {
    x_orig = _x;
    y_orig = _y;
    w = _w;
    h = _h;
  
    data = "No data";  
    
    my_font = createFont("Verdana-Italic", text_size);
  }
  
  void update(String new_data) { data = new_data; }
  
  void display() {
    //configure the pen and draw
    rectMode(CORNER);
    strokeWeight(stroke_weight);
    stroke(border_color);
    fill(fill_color);
    rect( x_orig, y_orig, width-1, height-y_orig-1);
    	
    //update data
    String[] new_data = loadStrings("scan.json");
    update(new_data[0]);
	
    //find the height in the center of the text box
    int text_y = ((height - y_orig) / 2) + y_orig + text_size/2;
    int text_x = x_orig + text_offset;

    //configure the pen and draw
    textAlign(LEFT);
    textFont(my_font);
    fill(text_color);
    text(data, text_x, text_y);
  
  }
  
  int transform(int h) {
    //transform a heading to reflect that our zero degree angle is usually 
    //represented as parallel to the y axis..or 'up' in the window.
    return (h-90);
  }
};

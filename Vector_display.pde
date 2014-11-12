/*
  Cosine vector display
    - This sketch is designed to visualize the scan from Alfred's
    scanner and display that data.
    - It consists of three classes.  
      1. Vector_window - a visual display of the scan
      2. Text_window - data from the latest scan
      3. Comms_manager - control serial comms to communicate with Alfred
*/

Reading r1 = new Reading(15, 38, 245);
Reading r2 = new Reading(20, 60, 330);
Reading r3 = new Reading(25, 90, 18);

Scan_msg m1 = new Scan_msg();

int window_x = 400;
int window_y = 300;
int text_size = 16;

Vector_window vector_window = new Vector_window(0, 0, window_x, 4*(window_y/5));
Text_window text_window = new Text_window(0, 4*(window_y/5), window_x , window_y/5);

PFont my_font;

void setup() {

  size(window_x, window_y,P2D);
  background(255);
  
  my_font = createFont("Verdana-Italic", text_size);
  textFont(my_font);
  textAlign(CENTER);
  
  print(r1.to_text());
  
  m1.add(r1);
  m1.add(r2);
  m1.add(r3);
  print(m1.to_text());
}

void draw() {
  //stroke(0); 
  fill(0);

  text_window.update(m1.to_text());
  text_window.display();
}


class Reading {
  int h;
  int r;
  long t;
  
  Reading() {
     h = 0;
     r = 0; 
  }
  
  Reading(long stamp, int heading, int range) {
    t = stamp;
    h = heading;
    r = range; 
  }
  
  long timestamp() { return t; }
  int heading() { return h;}
  int range() { return r; }
  
  String to_text() { return str(h) + ":" + str(r);}
};

class Scan_msg {
  ArrayList<Reading> readings;
  long t;  //timestamp of newest data
  
  Scan_msg() {
    readings = new ArrayList<Reading>();
    t = 0; 
  }
  
  void add(Reading r) {
    readings.add(r);
    if(r.timestamp() > t) t = r.timestamp();   
  }
  
  String to_text() {
    String res = "{stamp:" +t+",readings[";
    for( int i=0; i<readings.size(); i++) {
      Reading tmp = readings.get(i);
      res = res + tmp.to_text();
      //add a comma if its not the last element
      
      if(i != readings.size()-1) res += ",";
    } 
    res = res + "]}";
    
    return res;
  }
};

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

/*
  I need to add a point list for the tips of all the heading vectors.  
  
  I want a thin red line from the origin point in the direction of each
  heading to serve as a small unit vector that indicates the direction
  of each heading in the scan.
  
  Then under each unit vector will be a thicker black vector in the direction
  of any detected obstruction.
*/

//***********************************************************************
//                               CUSTOM TYPES
//***********************************************************************
class Obstruction{
  private int t;  //in degrees
  private int r;  

  Obstruction(int theta, int range){
    t = theta;
    r = range;
  }
  
  int theta() { return t; }
  void set_theta(int theta) { t = theta; }
  
  int range() { return r; }
  void set_range(int range) { r = range; }
  
  void print() {
    println(t + ":" + r);
  }
};

//***********************************************************************
//                          CLASS VECTOR WINDOW
//***********************************************************************
class Vector_window {
  int x;
  int y;
  int win_width;
  int win_height;
  int x_center;
  int y_center;
  
  int unit_vec_length;  //in pixels
  float range_scale;    //scale the range to fit in the display
  int scan_size;
    
  IntList headings;
  JSONObject scan;
  ArrayList<Obstruction> obstructions;
    
  Vector_window(int _x, int _y, int _width, int _height) {
    x = _x;
    y = _y;
    win_width = _width;
    win_height =_height; 
    x_center = (win_width - x) / 2;
    y_center = (win_height - y) /2;
    
    unit_vec_length = 10;
    range_scale = .7;
    scan_size = 5;
    
    headings = new IntList();
    obstructions = new ArrayList<Obstruction>();
  }
  
  void display() {
    //Draw the bot
    fill(0);
    rectMode(CENTER);
    rect(x_center, y_center, 5, 5);
    
    //Load obstructions
    scan = loadJSONObject("scan.json"); 
    for(int i=0; i<scan_size; i++) {
       //load the heading and range for each value of i
       String h_tag = "h"+i;
       String r_tag = "r"+i;
       int temp_h = scan.getInt(h_tag);
       int temp_r = scan.getInt(r_tag);

       //transform the heading
       temp_h = transform(temp_h);

       //save the Obstruction
       obstructions.add(new Obstruction(temp_h, temp_r));
    }
    
    //draw obstructions
    for (int i=0; i<obstructions.size(); i++) {
      draw_obstructions(obstructions.get(i));
    }
    
    //draw unit vectors
    for (int i=0; i<headings.size(); i++) {
        draw_unit_vec(headings.get(i));
    } 
  }
  
//***********************************************************************
//                               Helper functions
//***********************************************************************
  void add_obstruction(Obstruction obs) {
    int new_theta = transform(obs.theta());
    obs.set_theta(new_theta);
    obstructions.add(obs);
  }

  void add_heading(int h) { 
    headings.append( transform(h) ); 
  }

  int transform(int h) {
    //transform a heading to reflect that our zero degree angle is usually 
    //represented as parallel to the y axis..or 'up' in the window.
    return (h-90);
  }
  
  void draw_obstructions(Obstruction obs) {
    //for each obstruction in the array list I want to draw a vector that
    //originates at the x_center, y_center
    int theta = obs.theta();
    
    int x_tip_offset = int(range_scale * obs.range() * cos(to_radians(theta)));
    int y_tip_offset = int(range_scale * obs.range() * sin(to_radians(theta)));
    
    int x_tip = x_center + x_tip_offset;
    int y_tip = y_center + y_tip_offset;
    
    //configure the pen
    stroke(#000000);  //black
    strokeWeight(3);
    
    //draw
    line(x_center, y_center, x_tip, y_tip);
    
  }

  void draw_unit_vec(int h) {
    //for each heading I want to draw a unit vector of length ten pixels
    //that originates at the x_center, y_center
    int x_tip_offset = int(unit_vec_length * cos(to_radians(h)));
    int y_tip_offset = int(unit_vec_length * sin(to_radians(h)));
    
    int x_tip = x_center + x_tip_offset;
    int y_tip = y_center + y_tip_offset;
    
    //configure the pen
    stroke(#FF3300);  //dark red
    strokeWeight(1);
    
    //draw
    line(x_center, y_center, x_tip, y_tip);
  }
  
  float to_radians(int h) {
    final float deg_to_rad = PI/180; 
    return float(h) * deg_to_rad; 
  }
};

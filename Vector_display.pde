/*
  Cosine vector display
    - This sketch is designed to visualize the scan from Alfred's
    scanner and display that data.
    - It consists of three classes.  
      1. Vector_window - a visual display of the scan
      2. Text_window - data from the latest scan
      3. Comms_manager - control serial comms to communicate with Alfred
*/

Reading r1 = new Reading(0, 0, 245);
Reading r2 = new Reading(5, 30, 330);
Reading r3 = new Reading(10, -60, 18);

Scan_msg msg = new Scan_msg();

int window_x = 500;
int window_y = 600;

Vector_window vector_window = new Vector_window(0, 0, window_x, 4*(window_y/5));

Text_window text_window = new Text_window(0, 4*(window_y/5), window_x , window_y/5);


void setup() {

  size(window_x, window_y,P2D);
  background(255);
  
  print(r1.to_text());
  
  vector_window.add_heading(0);
  vector_window.add_heading(30);
  vector_window.add_heading(-60);
  println(vector_window.headings);
  
  msg.add(r1);
  msg.add(r2);
  msg.add(r3);
  println(msg.to_text());
}

void draw() {
  //stroke(0); 
  fill(0);

//  text_window.update(msg.to_text());
  text_window.display();
  
  vector_window.display();
}

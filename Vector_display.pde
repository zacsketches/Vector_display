/*
  Vector display
    - This sketch is designed to visualize the scan from Alfred's
    scanner and display that data.
    - It consists of three classes.  
      1. Vector_window - a visual display of the scan
      2. Text_window - data from the latest scan
      3. Comms_manager - control serial comms to communicate with Alfred
	- It uses a data file named scan.json to hold the contents of the latest scan
*/

import processing.serial.*;

int window_x = 500;
int window_y = 600;

Vector_window vector_window = new Vector_window(0, 0, window_x, 4*(window_y/5));

Text_window text_window = new Text_window(0, 4*(window_y/5), window_x , window_y/5);


Serial alfred_port = new Serial(this, Serial.list()[0], 57600);
Comms_manager comms_manager = new Comms_manager(alfred_port, 1);


void setup() {

  size(window_x, window_y,P2D);
  background(255);
}

void draw() {

  comms_manager.run();  

  text_window.display();
  
  vector_window.display();
}

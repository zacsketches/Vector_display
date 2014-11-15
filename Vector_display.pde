/*
  Vector display
    - This sketch is designed to visualize the scan from Alfred's
    scanner and display that data.
    - It consists of three classes.  
      1. Vector_window - a visual display of the scan
      2. Text_window - data from the latest scan
      3. Comms_manager - control serial comms to communicate with Alfred
      4. Serial_listbox - GUI element to select the serial port to attempt comms
         with Alfred.  Based on the GUIDO library example for list.pde with adaptation
         to include visibility toggle and loading the Serial.list() data.
	- It uses a data file named scan.json to hold the contents of the latest scan
*/

import de.bezier.guido.*;
import processing.serial.*;

Serial_listbox listbox;
Object lastItemClicked;

Serial alfred_port;
boolean port_opened = false;
int baud = 57600;
String port_instruction;
String port_feedback;
int open_time;
int feedback_display_time = 1500;

int window_x = 500;
int window_y = 600;
color text_color = color(0);

Vector_window vector_window = new Vector_window(0, 0, window_x, 4*(window_y/5));
Text_window text_window = new Text_window(0, 4*(window_y/5), window_x , window_y/5);
Comms_manager comms_manager;

void setup() {
  size(window_x, window_y, P2D);
  
  port_instruction = "Select a port to get scan data:";
  
  // Starte the GUI manager
  Interactive.make( this );
  
  // get the serial list
  String[] sl = Serial.list();
  
  // build the listbox
  listbox = new Serial_listbox( 20, 60, width-40, height-180 );
  for ( int i = 0; i < sl.length; i++ )
  {
      listbox.addItem(sl[i]);
  }
  
}

void draw() {

  background(255);
  
  //control the port selection
  open_serial_port();
  
  //once port has been set open the normal set of windows
  if(port_opened && (millis() > open_time + feedback_display_time)) {
	  //println("control flow running");
	  comms_manager.run();  

	  text_window.display();
  
	  vector_window.display();  		
  }

}

public void itemClicked ( int i, Object item )
{
  if(listbox.visible()) lastItemClicked = item;
}

void open_serial_port(){
	
	//if the port hasn't been opened display the port_instruction.
	//if the port has been opened display the port_feedback for the
	//feedback display time.
	
	if (!port_opened){
		fill(text_color); 
		text( port_instruction, 30, 35 );
	}
	if(port_opened && (millis() < open_time + feedback_display_time) ){
		fill(text_color);
		text(port_feedback, 30, 35);
	}
	
	if ( (lastItemClicked != null) && (!port_opened) ) { 
		String port_name = lastItemClicked.toString(); 
		try { 
			alfred_port = new Serial(this, port_name, baud); 
			port_feedback = "Opened " + port_name; port_opened = true;
			listbox.set_visible(false);
			open_time = millis();
			comms_manager = new Comms_manager(alfred_port, 1); 
		} catch (Exception e) { 
			println(e.getMessage());
			lastItemClicked = null; 
		} 
	}
}

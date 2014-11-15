Vector control display
======================

The next evolution in my control system for Alfred is the ability to 
use a single vector control as the output of the controller with the plant
translating that vector into motor commands.  This Processing sketch is
an effort to visualize this vector control system.

My design plan now is to have the sketch consist of three classes 

1. Vector_window - a visual display of the scan
2. Text_window - data from the latest scan
3. Comms_manager - control serial comms to communicate with Alfred

##Build Notes

1. Right now I've got the basic implementation done for the Text Window.
2. On 11/12 I began the class for displaying the obstruction vectors.  The window is formatted, but now I need to add the unit vectors along each heading.
3. I like this site for picking web safe colors
	http://designbynur.com/eng/color/216webcolors.htm
4. Unit vectors can now be added and displayed.  The next step is to plot the obstruction vectors.
  - Obstruction vectors will come from the scan message.
  - The scan message will eventually come from the serial port
  - Getting data out of the scan message will probably be most efficient if I rely on JSON.
  - HOWEVER...I think I want to focus today and the display of this data and not on the transmission of it.
  - So....I can manually add obstructions to the vector window with an ArrayList<Obstruction> where Obstruction is defined as a two int class.  TRY THIS.
5. Obstruction vectors can now be displayed by printing the data in the Obstructions ArrayList.  Not sure if this is the final data structure, but it's moving in the right direction.
6. It's time to get to work on handling the data flow.  Let' start by playing around with the JSON capability.
7. So after playing with JSON for a bit, I have a way to write and read a scan message into a JSON object.
  - The comm manager will write it's latest data to a file.
  - Vector window will read the file into a JSON object and display the data.
  - So I need to add the JSON Read into vector window
8. Ok...now I've got the vector_window reading from a JSON data file to find the heading unit vectors and the obstruction vectors.  Now I need to get the text_window to read from the same JSON file.  Then I need to take all the manual scan_msg and heading_add crap out of the main sketch.
9. Then after I've done that I'll need to finally implement the comms piece on both the Arduino and the Processing sketch.  This might force me to re-write the scanner simulator for the Glow Worm Block.
10. Step 8 is done on 11/15
11. I've got the basic comms manager requesting an update at a user configurable rate.  Now I need to go back to some of my old work and build listeners on both ends of the sketch.

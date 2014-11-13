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

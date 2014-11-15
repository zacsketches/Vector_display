/*
 * 3/16 STABLE  Designed to work with 'scanAndPlot_ArduinoSide7'.
 * COMPLETE - This spiral I'm trying to get the heading sent from Arduino and plotted.  
 * COMPLETE - The plot for the rest of the obstructions is not rectified to the vehicle heading.
 * 

*/

import processing.serial.*;

// Communication constants
Serial myPort;                      // Creating the serial port name we will use
boolean firstContact = false;       // Whether we've heard from the microcontroller
boolean configRcvd = false;         // Whether config data has been received
byte HEADER = '|';                  // the message header
byte EOT = '~';                     // End ofTransmission ASCII character
byte MEASUREMENT_COMM_LOCK = 1;
byte HEADING_COMM_LOCK = 2;
byte commLock = 0;

//Scan and plot config variables
int gridSize;                      //How big is the obstruction grid
int span;                          //How many degrees is the sensor scanning
int observationPoints;             //How many points in the span is the sensor measuring
int scale;                         //How many cm will each obstruction represent
PFont f;                           //Font for the plot
int fSize = 16;                        //Font size for the plot

//Flow control constants
boolean measurementInProgress = false;
boolean headingUpdateInProgress = false;

//Obstruction database variables
int[][] obstructions;             //Array 2D map of obstructions
int resolution;                   //the size of map in pixels
int obSize;                       //pixel size of an individual obstruction

//Vehicle plot test data
float heading;                 //for testing only.  Real heading will come from the bot
int Z_dot_x = 0;
int Z_dot_y = 0;

void setup() {
  smooth();
  f = createFont("BlackmoorLetPlain",12,true);
  // Print a list of the serial ports, for debugging purposes:
  //println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  establishContact();
  while(firstContact == false) {
    delay(250);                  //rcv configuration data before using it to size the
  }      
  
  myPort.bufferUntil(EOT);       //set the serial buffer to look for EOT

  getConfig();                   //get scan config data from Arduino
  while(configRcvd == false) {
    delay(250);                  //rcv configuration data before using it to size
  }                              //onbstructions array...taking this setp out 
                                 //causes a tricky array null pointer
  
  setUpMap();                    //Use config data to construct the plot area
}

void draw() {
  background(200);
  
  //plot vehicle location and heading
  plotVehicle();
  
  /* Draw the obstructions by interaring through the obstruction 2D 
   * array and plot a box for each obstruction.
  */
  for (int i=0; i<gridSize; i++) {
    for (int j=0; j<gridSize; j++) {
       if (obstructions[i][j] == 1) {
         fill(255);
         int xPlot = int(((i * resolution) / (gridSize)) + .5 * obSize);
         int yPlot = int(((j * resolution) / (gridSize)) + .5 * obSize);
         rectMode(CENTER);
         rect(xPlot, yPlot, obSize, obSize);
       }  
    }
  }
  
  //scan for obstructions
  if (measurementInProgress==false && commLock==0) {
    commLock = MEASUREMENT_COMM_LOCK;
    measurementInProgress=true;
  }
  while (commLock==MEASUREMENT_COMM_LOCK) {
      myPort.write('s');
//      println("Awaiting measurement data from Arduino");
      delay(250);
  } 
}

void getHeading() {
  /*Arduino listens for 'h' to send configuration data */
  if(headingUpdateInProgress == false && commLock==0) {
    commLock = HEADING_COMM_LOCK;
    headingUpdateInProgress = true;
  }
  while (commLock == HEADING_COMM_LOCK) {
     myPort.write('h');
     println("Awaiting heading from Arduino");
     delay(250);     
  }
}

void plotVehicle() {
  /* I will need to update this function to show the position of the vehicle
   * and not just the center of the plot
   */
  PVector v, v1, v2;
  getHeading();
  float Z = heading;
  float Z1 = Z+.175;          //subtle angle shifts to set up the arrow head angles
  float Z2 = Z-.175;
  int x = getXPos();
  int y = getYPos();
  int center = (resolution)/2;
  
  textFont(f,fSize);
  fill(0);
  textAlign(CENTER);
  
  v = PVector.fromAngle(Z);    //create a vector for heading.
  v1 = PVector.fromAngle(Z1);
  v2 = PVector.fromAngle(Z2);
  v.mult(50);                  //scale the heading
  v1.mult(40);
  v2.mult(40);
  
  translate(center, center);
  float rotation = .5*PI+Z;
  rotate(rotation);
  text("Z",x,y);      //display the position of the sensor
  rotate(-rotation);
  line(0,0,v.x, v.y);
  line(v.x, v.y, v1.x, v1.y);
  line(v.x, v.y, v2.x, v2.y);  
  int origin = center*-1;
  translate(origin,origin);
  
}

/*Duplicates work in the draw function
void requestScan() {
    myPort.write('s');
}
*/

/* duplicates work in getHeading()
void requestHeading() {
    myPort.write('h'); 
}
*/

int getXPos(){
  int xPos = Z_dot_x;
  return xPos;  
}

int getYPos() {
  int yPos=Z_dot_y;
  return yPos;
}


void trans(int xCoord, int yCoord, int sign) {
  /* x and y coords from the arduino are not mapped to the display grid for processing
   * Therefore this function takes the x and y data and maps it to grid size.
   * Sign is 0-3 and is a binary code for the sign of each coord
      00 is x pos, y pos 
      01 is x pos, y neg
      10 is x neg, y pos
      11 is x neg, y neg
   */
  switch (sign) {
    case 1:
      yCoord = yCoord * -1;
      break;
    case 2:
      xCoord = xCoord * -1;
      break;
    case 3:
      yCoord = yCoord * -1;
      xCoord = xCoord * -1;
      break;
  }
  xCoord = xCoord/scale;      //apply the scale
  yCoord = yCoord/scale;      //apply the scale

  int center = (gridSize-1)/2;
  xCoord += center;
  yCoord = center - yCoord;
  
  if ((xCoord < gridSize) && (yCoord < gridSize)) {
      obstructions[xCoord][yCoord]=1;              //save an obstruction in the database 
      println("Saved the following coord: " + xCoord + ", " + yCoord);
    } else {
      println("Coord out of array bounds for obstructions [][]");
  }
}

void setUpMap() {
  obstructions = new int[gridSize][gridSize];  //sizes the obs 2D array
  resolution = 705 - (705 % gridSize);        //makes it come out en even multiple of grid size
  size(resolution, resolution); 
  obSize = resolution/gridSize;              //provides the pixel size that each obs is plotted at
  println("Map setup is as follow:");
  println("resolutions is: " + resolution);
  println("object size is: " + obSize + " pixels");
  float scaler = scale * gridSize/100;
  println("Based on the scale the plot will map a square area " + scaler + " meters per side");
  println("------------------");

  
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port if first contact has been established:
  if (firstContact==true) {
    byte[] inBuffer= myPort.readBytes();
    int bufferSize = inBuffer.length;
    println("The buffer size is " + bufferSize + " items long.");
    if (inBuffer[0]==HEADER) {      
        println("Header rcvd.");
        switch (inBuffer[1]) {
          case 'c':               //tag for config data.  Expecting three ints back
            println("Scan is configured as follows: ");
            span = combineBytes(inBuffer[2], inBuffer[3]);
            println("The span is " + span + " degrees"); 
            observationPoints = combineBytes(inBuffer[4], inBuffer[5]);
            println("There are " + observationPoints + " observation points.");
            gridSize = combineBytes(inBuffer[6], inBuffer[7]);
            println("The grid size is " + gridSize);
            scale = combineBytes(inBuffer[8], inBuffer[9]);
            println("The scale size is " + scale);
            println("------------------");
            configRcvd = true;
            break;
         case 'm':
            /* Arduino is sending measurment data for the plot.
             * The message should be in a ten byte buffer broken
             * into an xPos, yPos, sign and checksum
             * the x, y and sign are broken into six bytes.... 
             * xHigh, xLow, yHigh, yLow, signHigh and signLow.
             * see the trans function for an explanation of the sign coding
             * I can improve this function by having Processing ask for 
             * measurement again if the checksums don't match
             */
            if (bufferSize==10) {                       
              int xPos = combineBytes(inBuffer[2], inBuffer[3]);
              int yPos = combineBytes(inBuffer[4], inBuffer[5]);
              int sign = combineBytes(inBuffer[6], inBuffer[7]);
              int checkSumRcvd = inBuffer[8];
              int checkSumCalculated = findCheckSum(xPos, yPos, sign);
              myPort.clear();
         //     myPort.write(checkSumCalculated);
              measurementInProgress = false;
              commLock = 0;
              printMeasurementData(xPos, yPos, sign, checkSumRcvd, checkSumCalculated);
              boolean coordInLimits = testCoord(xPos, yPos);
              if ((checkSumCalculated == checkSumRcvd) && (coordInLimits)) {
                  trans(xPos, yPos, sign);
                  println("coord plotted");
                  println("---------------------------------");
              }
            } else {
              println("Buffer too short for measurement data");
              println("---------------------------------");
            }    
            break;
         case 'h':
            /* Arduino is sending heading data for the plot.
             * The message should come in an 6 byte buffer broken
             * into a high and low byte of data.  The info is passed
             * in degrees and must be converted to radians.
             */
            if (bufferSize==6) {
              int z = combineBytes(inBuffer[2], inBuffer[3]);
              int checkSumRcvd = inBuffer[4];
              int checkSumCalculated = findCheckSum(0, 0, z);
              myPort.clear();
              z -= 90;              //adjust for offset between true north and Processing plot
              float Z = z*PI/180;
              heading = Z;
              headingUpdateInProgress = false;
              commLock = 0;
              printHeadingData (Z, checkSumRcvd, checkSumCalculated);
              
            }   
       }
    }
  }
}

boolean testCoord(int xPos, int yPos) {
   boolean coordInLimits = false;
   if ((xPos < gridSize) && (yPos < gridSize)) {
       coordInLimits = true; 
   } 
   if (coordInLimits) {
       println("Coord is within plot boundaries");
   } else {
       println("Coord out of limits");
       println("********************************"); 
   }
   return coordInLimits; 
}

int findCheckSum(int x, int y, int sign) {
    int sum = x + y + sign;
    int checkSum = sum % 128;
    return checkSum;  
}

int combineBytes(byte high, byte low) {
  /* This was a pain to figure out.  Processing defines bytes from -128 to 128.  Arduino
     defines bytes as 0 to 256.  Therefore, I couldn't get 180 to ship over right.  by
     changing how the low and high byte are defined we are getting pretty good results!
  */ 
  int temp = high*128;
  temp = temp + low;
  return temp;
}

void getConfig() {
  /*Arduino listens for 'c' to send configuration data */
  while(configRcvd == false) {
    myPort.write('c'); 
    delay(300);
  }
}

void establishContact() {
  while(firstContact == false) {
      myPort.write('A');        //send the initialize to the arduino 
      delay(300);
      if (myPort.read() == 1) {
        firstContact = true; 
        myPort.clear();          // clear the serial port buffer
        println("________________________");
        println("Communication with Arduino established.");
        println("________________________");
      }
  }
}

void printMeasurementData(int xPos, int yPos, int sign, int checkSumRcvd, int checkSumCalculated) {
              println("Measurment data follows: ");
              println("X is:" + xPos + " Y is:" + yPos + " Sign is:" + sign);
              println("checkSumRcvd: " + checkSumRcvd);
              println("checkSumCalculated: " + checkSumCalculated);
}

void printHeadingData(float Z, int checkSumRcvd, int checkSumCalculated) {
     println("Heading data follows: ");
     println("Z is:" + Z);
     println("checkSumRcvd: " + checkSumRcvd);
     println("checkSumCalculated: " + checkSumCalculated);
     println("----------------------");

}


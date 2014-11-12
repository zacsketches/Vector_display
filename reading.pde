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

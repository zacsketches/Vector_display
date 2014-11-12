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


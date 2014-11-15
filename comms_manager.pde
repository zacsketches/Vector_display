//************************************************************************
//*                         COMMS MANAGER
//************************************************************************
class Comms_manager {
	int freq;
	int rate;
	boolean echo;

	Serial comms_port;
	int last_update;
	
        //constructor with default echo
	Comms_manager(Serial port, int frequency) {
		comms_port = port;
		
		freq = frequency;
		rate = int(1*1000/freq);
		
		echo = true;
				
		last_update = 0;
	}

	void set_echo(boolean val) {echo = val;}
	
	void run() {
		int now = millis();
		if(now > (last_update + rate) ) {
			last_update = now;
			//send 's' to the serial port to request a scan
			alfred_port.write('s');
			if(echo) println('s');
		} 
		
		
	}
	
};

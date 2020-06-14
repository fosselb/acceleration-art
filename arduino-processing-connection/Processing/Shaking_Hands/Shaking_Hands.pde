import processing.serial.*;

Serial myPort;
String val;
boolean firstContact = false;

void setup() {
  size(200, 200);
  myPort = new Serial(this, Serial.list()[3], 9600);
  myPort.bufferUntil('\n');
}

void draw() {
}

void serialEvent(Serial myPort) {
  val = myPort.readStringUntil('\n');  // put incoming data into a string.
                                       // '\n' is our end delimiter indicating the end of a complete packet
  
  if (val != null) {
    val = trim(val);    // trim whitesapce & formatting characters (like '\n')
    println(val);
    
    if (firstContact == false) {
      if (val.equals("A")) {
        myPort.clear();
        firstContact = true;
        myPort.write("A");
        println("contact");
      }
    } else {
      //println(val);
      
      if (mousePressed == true) {
        myPort.write('1');
        println("1");
      }
      
      myPort.write("A");
    }
  }
}

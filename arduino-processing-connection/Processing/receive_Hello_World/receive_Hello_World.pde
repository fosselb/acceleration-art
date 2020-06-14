import processing.serial.*;

Serial myPort;   // Create object from Serial class
String val;      // Data received from the serial port

//printArray(Serial.list());  // find what serial port to use

void setup() {
  String portName = Serial.list()[3];        // change to match port
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  if (myPort.available() > 0) {
    val = myPort.readStringUntil('\n');
  }
  println(val);
}

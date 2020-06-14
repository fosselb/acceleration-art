import processing.serial.*;

Serial myPort;        // create object from Serial class

void setup() {
  size(200, 200);    // set canvas size
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  if (mousePressed == true) {
    myPort.write('1');
    println("1");
  } else {
    myPort.write('0');
  }
}

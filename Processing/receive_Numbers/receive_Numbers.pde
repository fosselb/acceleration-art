// receive_Numbers.ino
// Author: Fosse Lin-Bianco
// Purpose: To display acceleration data in the visual form of circles and color
// Notes: This program runs in conjunction with myMPU-6050 created ELEGOO and tweaked by Michael Schoeffler


import processing.serial.*;

Serial myPort;   // Create object from Serial class
String val;      // Data received from the serial port
Boolean pauseScreen = false;

//printArray(Serial.list());  // find what serial port to use

void setup() {
  String portName = Serial.list()[3];        // change to match port
  myPort = new Serial(this, portName, 9600);
  
  size(1000, 1000);
  background(0);
}

void draw() {
  if (myPort.available() > 0) {
    val = myPort.readStringUntil('\n');
  }
  
  val = trim(val);
  if (val == null || val == "") {
    val = "0";
  }
  println(val);
  
  if (val != null || val != "") {
    float rand_x = random(width);
    float rand_y = random(height);
    
    int diameter = abs(Integer.parseInt(val) / 100);
    
    fill(rand_x, 200, rand_y);
    ellipse(rand_x, rand_y, diameter, diameter);
    //ellipse(rand_x, rand_y, 100, 100);
  }
  
  delay(100);
}

public void keyPressed() {
    if (key == ' ') {
      pauseScreen = !pauseScreen;
      if (pauseScreen) {
        noLoop();
      } else {
        loop();
      }
    }
  }

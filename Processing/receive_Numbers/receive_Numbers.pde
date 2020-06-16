// receive_Numbers.pde
// Author: Fosse Lin-Bianco
// Purpose: To display acceleration data in the visual form of circles and color
// Notes: This program runs in conjunction with myMPU-6050 created by ELEGOO and tweaked by Michael Schoeffler

import processing.serial.*;

Serial myPort;   // Create object from Serial class
String val;      // Data received from the serial port
Boolean pauseScreen = false;

public static int borderHeight = 10;
public static int buttonDiameter = 35;
public static int buttonSpacing = 150;

public static int canvasWidth = 800;
public static int canvasHeight = 800;
public static int userInterfaceHeight = buttonDiameter + borderHeight*2;

Boolean editingMode = false;

//printArray(Serial.list());  // find what serial port to use

void setup() {
  if (!editingMode) {
    String portName = Serial.list()[3];        // change to match port
    myPort = new Serial(this, portName, 9600);
  }
  
  size(820, 910);
  //fullScreen();
  background(0);
  drawUserInterface();
}

void draw() {
  if (myPort.available() > 0 && !editingMode) {
    val = myPort.readStringUntil('\n');
  
  
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
  
public void drawUserInterface() {

  //rect(0, 100, width - 1, 20);
  
  // title
  textSize(32);
  text("Digital Movement Art", borderHeight, borderHeight*4);
  
  // canvas screen
  stroke(255);
  noFill();
  rect(borderHeight, userInterfaceHeight, canvasWidth, canvasHeight);
  
  // control buttons
  fill(255);
  ellipse(buttonDiameter/2 + borderHeight, height - borderHeight - buttonDiameter/2, buttonDiameter, buttonDiameter);
  ellipse(buttonDiameter/2 + borderHeight + buttonSpacing, height - borderHeight - buttonDiameter/2, buttonDiameter, buttonDiameter);
  ellipse(buttonDiameter/2 + borderHeight + buttonSpacing*2, height - borderHeight - buttonDiameter/2, buttonDiameter, buttonDiameter);

  // control button labels
  textSize(20);
  text("Start", borderHeight*2 + buttonDiameter, userInterfaceHeight + canvasHeight + borderHeight + 25);
  textSize(20);
  text("Stop", borderHeight*2 + buttonDiameter + buttonSpacing, userInterfaceHeight + canvasHeight + borderHeight + 25);
  textSize(20);
  text("Save", borderHeight*2 + buttonDiameter + buttonSpacing*2, userInterfaceHeight + canvasHeight + borderHeight + 25);

  // recording button
  noStroke();
  fill(255, 0, 0, 150);
  ellipse(width - buttonDiameter/4 - borderHeight, borderHeight*2, buttonDiameter/2, buttonDiameter/2);

}

// receive_Numbers_v2.pde
// Author: Fosse Lin-Bianco
// Purpose: To display acceleration data in the visual form of circles and color. Version 2.
//          Key presses and click for controls. No buttons.
// Notes: This program runs in conjunction with myMPU-6050 created by ELEGOO and tweaked by Michael Schoeffler

import processing.serial.*;

Serial myPort;   // Create object from Serial class
String val;      // Data received from the serial port
Boolean pauseScreen = false;

public int gameState = 0;
public Boolean recording = false;

public int borderHeight = 10;
public int buttonDiameter = 35;
public int buttonSpacing = 150;
public int textSpacing = 45;

public int canvasWidth = 800;
public int canvasHeight = 800;
public int userInterfaceHeight = buttonDiameter + borderHeight*2;

public String currentDateAndTime = get_date_and_time();
public String currentDate = get_date();
public String screenshotsFileLocation = "/Users/fosselin-bianco/Documents/LMU/Senior Project/digital-movement-art/digital-art-pieces/screenshots/";
public String animationFileLocation = "/Users/fosselin-bianco/Documents/LMU/Senior Project/digital-movement-art/digital-art-pieces/animation/";

public int shotCounter = 0;

//printArray(Serial.list());  // find what serial port to use

void setup() {
  serialSetup();
  size(800, 800);
  background(0);
}

void draw() {
  if (gameState == 0) {
    initScreen();
  } else if (gameState == 1) {
    sketchScreen();
  }
}

// Methods

public void sketchScreen() {
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
  
  if (recording) {
    //saveFrame("output/sketch-####.png");
    //saveFrame("/Users/fosselin-bianco/Documents/LMU/Senior Project/digital-movement-art/digital-art-pieces/animation/####.png");
    
    //String animationFileLocation_and_Name = animationFileLocation + currentDate + '/' + "shot-" + shotCounter + '/' + "####.png";
    
    String animationFileLocation_and_Name = animationFileLocation + currentDate + '/' + "shot-" + currentDateAndTime + '/' + "####.png";
  
    saveFrame(animationFileLocation_and_Name);
  }
  
  stroke(1);
  
  delay(100);
}

public void keyPressed() {
  //pause
  if (key == ' ' && gameState == 1) {
    pauseScreen = !pauseScreen;
    if (pauseScreen) {
      noLoop();
    } else {
      loop();
    }
  }
  
  // save image
  if ((key == 's' || key == 'S') && gameState == 1) {
    String fileName = get_date_and_time();
    String screenshotFileLocation_and_Name = screenshotsFileLocation + currentDate + '/' + fileName + ".png";
  
    save(screenshotFileLocation_and_Name);
    //save("/Users/fosselin-bianco/Documents/LMU/Senior Project/digital-movement-art/digital-art-pieces/test-save.png");
  }
  
  // record movie
  if ((key == 'r' || key == 'R') && gameState == 1) {
    recording = !recording;
    
    //if (lastCurrentDate == currentDate && recording) {
    //  shotCounter++;
    //} else if (lastCurrentDate != currentDate && recording) {
    //  shotCounter = 1;
    //  lastCurrentDate = currentDate;
    //}
  }
  
  // exit
  if (key == '`') {
    exit();
  }
}

public void mouseClicked() {
  if (gameState == 0) {
    eraseWelcomeIntructions();
    gameState = 1;
  }
}

public void serialSetup() {
  String portName = Serial.list()[3];        // change to match port
  myPort = new Serial(this, portName, 9600);
}

public void initScreen() {
  //fill(0, 255, 0, 100);
  //rect(0, 0, width, height);
  fill(255);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Digital Movement Art", width/2, height/2 - textSpacing*4);
  textSize(30);
  text("created by Fosse Lin-Bianco", width/2, height/2 + textSpacing - textSpacing*4);
  textSize(30);
  text("Press SPACE BAR to pause/play", width/2, height/2 + textSpacing*3 - textSpacing*4);
  textSize(30);
  text("Press S key to save sketch", width/2, height/2 + textSpacing*4 - textSpacing*4);
  textSize(30);
  text("Press R key to record sketch", width/2, height/2 + textSpacing*5 - textSpacing*4);
  textSize(30);
  text("CLICK anywhere to begin", width/2, height/2 + textSpacing*7 - textSpacing*4);
  
}

public void eraseWelcomeIntructions() {
  fill(0);
  rect(0, 0, width, height);
}

public String get_date_and_time() {
  String[] date_and_time = new String[6];

  date_and_time[0] = String.valueOf(year());
  date_and_time[1] = String.valueOf(month());
  date_and_time[2] = String.valueOf(day()); 
  date_and_time[3] = String.valueOf(hour());
  date_and_time[4] = String.valueOf(minute());
  date_and_time[5] = String.valueOf(second());
  
  String s = join(date_and_time, ".");
  //println(s);
  
  return s;
}

public String get_date() {
  String[] date = new String[3];

  date[0] = String.valueOf(month());
  date[1] = String.valueOf(day());
  date[2] = String.valueOf(year());
  
  String s = join(date, "-");
  //println(s);
   
  return s;
}


public void addRecordingButton(int x, int y) {
  //fill(255, 0, 0);
  noStroke();
  int rectWidth = 25;
  int rectHeight = 15;
  rect(x, y, rectWidth, rectHeight);
  triangle(x + rectWidth - 5, y + rectHeight/2, x + rectWidth + 10, y - 3, x + rectWidth + 10, y + rectHeight + 3);
}

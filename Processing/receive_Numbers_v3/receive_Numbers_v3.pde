// receive_Numbers_v3.pde
// Author: Fosse Lin-Bianco
// Purpose: To display acceleration data in the visual form of circles and color. Version 3.
//          Key presses and click for controls. No buttons.
// Notes: This program runs in conjunction with Accelerometer_Read.ino created by Fosse Lin-Bianco

import processing.serial.*;
//import processing.sound.*;
//SinOsc sine;

Serial myPort;   // Create object from Serial class

PGraphics canvas;

public String val;      // Data received from the serial port
public String[] accel_data = new String[3]; // x, y, z data from Arduino
public String[] axis_label = {"Z", "Y", "X"};
public int[][] colors = { {67, 188, 205}, // circle 1
                          {234, 53, 70},  // circle 2
                          {102, 46, 155}  // circle 3
                        };

Boolean firstContact = false;
Boolean pauseScreen = false;

public int gameState = 0;
public Boolean recording = false;
public int frame_number = 0;

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
public String dataFileLocation = "/Users/fosselin-bianco/Documents/LMU/Senior Project/digital-movement-art/digital-art-pieces/data/";

public int shotCounter = 0;

public int numberOfDataPointsOnScreen = 0;
public final int dataPointLimit = 500;

public Table dataTable = new Table();

void setup() {
  serialSetup();
  createTable(dataTable);
  size(800, 800);
  //background(0);
  
  canvas = createGraphics(width * 2, height * 2);
  
  // Create the sine oscillator.
  //sine = new SinOsc(this);
  //sine.play();
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
    val = myPort.readStringUntil('\n');  // put incoming data into a string.
                                         // '\n' is our end delimiter indicating the end of a complete packet
    if (val != null) {
      val = trim(val);    // trim whitesapce & formatting characters (like '\n')
      
      if (firstContact == false) {
        if (val.equals("A")) {
          myPort.clear();
          firstContact = true;
          myPort.write("A");
          println("contact");
        }
      } else {    
        if (mousePressed == true) {
          myPort.write('1');
          println("1");
        }
        
        myPort.write("A");
        
        if (val != null || val != "") {     
           
           accel_data = split(val, "\t");
           
           for (int i = 0; i < accel_data.length; i++) {
             if (accel_data[i] != null) {
               println(axis_label[i] + ": " + accel_data[i]);
             }
          
              canvas.beginDraw();
          
              // * draw circles *
              float rand_x = random(canvas.width);
              float rand_y = random(canvas.height);
              int diameter = abs(Integer.parseInt(accel_data[i]));
              
              canvas.fill(colors[i][0], colors[i][1], colors[i][2]);
              canvas.ellipse(rand_x, rand_y, diameter, diameter);
              canvas.endDraw();
              
              //background(0);
              image(canvas, 0, 0, width, height);
          
           }
           
              //// * draw circle 1 *
              //float rand_x = random(width);
              //float rand_y = random(height);
              //int diameter = abs(Integer.parseInt(accel_data[0]));
              //fill(67, 188, 205); //light blue
              //ellipse(rand_x, rand_y, diameter, diameter);
              
              //// * draw circle 2 *
              //rand_x = random(width);
              //rand_y = random(height);
              //diameter = abs(Integer.parseInt(accel_data[1]));
              //fill(234, 53, 70); //red orange
              //ellipse(rand_x, rand_y, diameter, diameter);
              
              //// * draw circle 3 *
              //rand_x = random(width);
              //rand_y = random(height);
              //diameter = abs(Integer.parseInt(accel_data[2]));
              //fill(102, 46, 155); //purple
              //ellipse(rand_x, rand_y, diameter, diameter);
          
          // * play sound *
          //sine.freq(float(val));
          
          // * save dataTable *
          saveData(dataTable);
          
          // * number of data points on screen *
          //numberOfDataPointsOnScreen++;
          //println(numberOfDataPointsOnScreen);
        
        
        // save Frames
          if (recording) {
            String frame_number_string = nf(frame_number, 4);
            //String animationFileLocation_and_Name = animationFileLocation + currentDate + '/' + "shot-" + currentDateAndTime + '/' + "####.png";
            //saveFrame(animationFileLocation_and_Name);
            
            String animationFileLocation_and_Name = animationFileLocation + currentDate + '/' + "shot-" + currentDateAndTime + '/' + frame_number_string + ".png";
            canvas.save(animationFileLocation_and_Name);
            frame_number++;
            
            myPort.write('R');
            println("R");
          } else {
            myPort.write('N');
            println("N");
          }
        }
      }
    }
  }
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
    //save(screenshotFileLocation_and_Name);
    canvas.save(screenshotFileLocation_and_Name);
    myPort.write('S');
    println("S");
  }
  
  // record movie
  if ((key == 'r' || key == 'R') && gameState == 1) {
    //recording = !recording;
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
  String portName = Serial.list()[4];        // change to match port
  //printArray(Serial.list());  // find what serial port to use
  
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
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

public String get_time() {
  String[] time = new String[3];

  time[0] = String.valueOf(hour());
  time[1] = String.valueOf(minute());
  time[2] = String.valueOf(second());
  
  String s = join(time, ":");

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

public void saveData(Table t) {
  TableRow newRow = t.addRow();
  newRow.setString("date", currentDate);
  newRow.setString("time", get_time());
  
  for (int i = 0; i < accel_data.length; i++) {
    newRow.setInt("accel_" + axis_label[i], Integer.parseInt(accel_data[i]));
  }
  
  //newRow.setInt("accel_X", Integer.parseInt(accel_data[0]));
  //newRow.setInt("accel_Y", Integer.parseInt(accel_data[1]));
  //newRow.setInt("accel_Z", Integer.parseInt(accel_data[2]));
  
  String dataFileLocation_and_Name = dataFileLocation + currentDate + '/' + "shot-" + currentDateAndTime + ".csv";
  
  saveTable(t, dataFileLocation_and_Name);
}

public void createTable(Table t) {  
  t.addColumn("date");
  t.addColumn("time");
  t.addColumn("accel_Z");
  t.addColumn("accel_Y");
  t.addColumn("accel_X");
}

public void calibrate() {

}

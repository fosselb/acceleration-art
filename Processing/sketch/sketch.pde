// sketch.pde
// Author: Fosse Lin-Bianco
// Purpose: To display acceleration data in the visual form of circles and color.
//          Key presses and click for controls.
// Notes: This program runs in conjunction with XBee_Coordinator_Receive_Analog.ino
//          created by Fosse Lin-Bianco

import processing.serial.*;

Serial myPort;

PGraphics canvas;

public String val; // data received from the serial port
public String[] incoming_data = new String[3];
public String[] accel_data = new String[3]; // z, y, x data from Arduino
public String[] axis_label = {"Z", "Y", "X"};

// * Tests 1.0 (forward roll) *
//public int[][] colors = { {67, 188, 205}, // circle 1
//                          {234, 53, 70},  // circle 2
//                          {102, 46, 155}  // circle 3
//                        };

// * Tests 2.0 - 2.2 (forawrd roll) *
//public int[][] colors = { {201, 251, 255}, // circle 1
//                          {219, 84, 97},  // circle 2
//                          {255, 217, 206}  // circle 3
//                        };

// * Tests 2.3 - 2.5 (cartwheel) *
//public int[][] colors = { {137, 4, 61}, // circle 1
//                          {28, 48, 65},  // circle 2
//                          {24, 242, 178}  // circle 3
//                        };
                        
// * Tests 2.6 - 2.8 (back hand spring) *
//public int[][] colors = { {8, 7, 8}, // circle 1
//                          {253, 202, 64},  // circle 2
//                          {230, 232, 230}  // circle 3
//                        };
                        
// * Tests 2.9 - 2.11 (swish to flying kick) *
//public int[][] colors = { {255, 123, 156}, // circle 1
//                          {96, 113, 150},  // circle 2
//                          {232, 233, 237}  // circle 3
//                        };
                        
// * Tests 3.0 - 3.2 (kip up) *
//public int[][] colors = { {241, 91, 181}, // circle 1
//                          {254, 228, 64},  // circle 2
//                          {0, 187, 249}  // circle 3
//                        };
                        
// * Tests 3.3 - 3.5 (handstand) *
//public int[][] colors = { {152, 206, 0}, // circle 1
//                          {22, 224, 189},  // circle 2
//                          {120, 195, 251}  // circle 3
//                        };
                        
// * Tests 3.6 - 3.8 (aerial) *
//public int[][] colors = { {242, 84, 45}, // circle 1
//                          {245, 223, 187},  // circle 2
//                          {14, 149, 148}  // circle 3
//                        };
                        
// * Tests 4.0 - 6.2 (stepping & acrobatics sequences) *
//public int[][] colors = { {7, 160, 195}, // circle 1
//                          {240, 200, 8},  // circle 2
//                          {221, 28, 26}  // circle 3
//                        };

// * 1st touch / wiggle [Lifted Colors] *
//public int[][] colors = { {228, 87, 46}, // orange
//                          {23, 190, 187},  // turquoise
//                          {255, 201, 20}  // yellow
//                        }; 
                        
// * Balance * 
//public int[][] colors = { {118, 4, 33}, // burgundy
//                          {57, 70, 72},  // gray
//                          {105, 153, 93}  // 50s green
//                        }; 
                        
// * Balance v2 *
//public int[][] colors = { {135, 0, 88}, // plum
//                          {200, 214, 175},  // lighter 50s green
//                          {164, 48, 63},  // orangeish burgundy
//                        }; 
                        
// * Drop Slide on Wall *
//public int[][] colors = { {0, 63, 145}, // blue
//                          {255, 255, 255},  // white
//                          {109, 50, 109}  // deep purple
//                        }; 
                        
// * White/Regular Shoe Transition Jump * Eh
//public int[][] colors = { {243, 198, 119}, // tan/golden
//                          {249, 86, 79},  // deep orange coral
//                          {123, 30, 122}  // plum purple
//                        }; 

// * Transition to/from New/Old World *
//public int[][] colors = { {52, 138, 167},  // blue
//                          {93, 211, 158}, // green
//                          {82, 81, 116}  // purple
//                        };

// * Arm Swipe, Coffee Grinder, Leg Snake [Smooth Colors] *
//public int[][] colors = { {68, 109, 246}, // bright blue
//                          {0, 99, 93},  // blue/green
//                          {8, 164, 189}  // green
//                        };

// * Foot Slide *
//public int[][] colors = { {214, 64, 69}, // red
//                          {233, 255, 249},  // very light blue
//                          {29, 51, 84}  // deeper blue
//                        }; 
                        
// * Foot Slide v2 *
//public int[][] colors = { {179, 0, 27}, // red
//                          {38, 38, 38},  // gray
//                          {37, 92, 153}  // deeper blue
//                        }; 

// * Handstand v2 and Arm Swipe *
public int[][] colors = { {0, 99, 93}, // deep green
                          {8, 164, 189},  // light blue
                          {68, 109, 246}  // deeper/lighter blue
                        }; 
                        
// * Other: Coral and Green *
//public int[][] colors = { {255, 111, 89}, // coral
//                          {37, 68, 65},  // dark green
//                          {67, 170, 139}  // lighter green
//                        }; 

// * Other: Violet and Orange *
//public int[][] colors = { {68, 53, 91}, // coral
//                          {236, 167, 44},  // dark green
//                          {238, 86, 34}  // lighter green
//                        }; 

Boolean firstContact = false;
Boolean pauseScreen = false;

public int gameState = 0;
public Boolean recording = true;
public int frame_number = 0;
public int timeline_number = 0;
public int radius = 200;
public float angle = 0;
public float angleSpeed = 1;

public int borderHeight = 10;
public int buttonDiameter = 35;
public int buttonSpacing = 150;
public int textSpacing = 45;

public int userInterfaceHeight = buttonDiameter + borderHeight*2;

public String currentDateAndTime = get_date_and_time();
public String currentDate = get_date();
public String screenshotsFileLocation = "/Users/fosselin-bianco/Documents/Digital-Movement-Art/Honors-Summer-Research-2020/digital-movement-art/digital-art-pieces/screenshots/";
public String animationFileLocation = "/Users/fosselin-bianco/Documents/Digital-Movement-Art/Honors-Summer-Research-2020/digital-movement-art/digital-art-pieces/animation/";
public String dataFileLocation = "/Users/fosselin-bianco/Documents/Digital-Movement-Art/Honors-Summer-Research-2020/digital-movement-art/digital-art-pieces/data/";

public int shotCounter = 0;

public Table dataTable = new Table();

void setup() {
  serialSetup();
  createTable(dataTable);
  background(0);
  
  // * 1:1 canvas *
  //size(800, 800);
  
  // * 16:9 canvas *
  size(960, 540);
  
  pixelDensity(displayDensity());
  
  canvas = createGraphics(width, height);
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
    val = myPort.readStringUntil('\n'); // put incoming data into a string.
                                        // '\n' is our end delimiter indicating the end of a complete packet
    if (val != null) {
      val = trim(val); // trim whitesapce & formatting characters (like '\n')
      
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
           
           incoming_data = split(val, "\t");
           
           if (incoming_data.length > 3) {
             accel_data = subset(incoming_data, 0, 3);
           } else {
             accel_data = incoming_data;
           }
           
           for (int i = 0; i < accel_data.length; i++) {
             if (accel_data[i] == null) {
               accel_data[i] = "0";
             }
             
              println(axis_label[i] + ": " + accel_data[i]);
          
              // * draw circles *
              canvas.beginDraw();
          
              float rand_x = random(canvas.width);
              float rand_y = random(canvas.height);
              
              int dataPoint = Integer.parseInt(accel_data[i]);
              int diameter = abs(dataPoint) / 2;
              
              //if (diameter < 25) {
              //  diameter = diameter / 3;
              //}
              
              canvas.fill(colors[i][0], colors[i][1], colors[i][2]);
              
              // * Tests 1.0 - 3.8 *
              //diameter = diameter * 2;
              //canvas.ellipse(rand_x, rand_y, diameter, diameter);
              
              // * Tests 4.0 - 5.0 *
              //canvas.ellipse(timeline_number, height/2, diameter, diameter);
              
              // * Tests 6.0 - 6.2 *
              //canvas.ellipse(timeline_number * 2, height/2, diameter, diameter);
              
              // * Experiment 2.0 *
              //canvas.ellipse(timeline_number * 9, height/2, diameter*4, diameter*4);
              
              // * Experiment Circle Trace *
              int[] rectCoordinates = polarToRectPixels(radius, angle);
              canvas.ellipse(width/2 + rectCoordinates[0], height/2 + rectCoordinates[1], diameter, diameter);
              
              // * Experiment Different Speed Lines *
              //canvas.ellipse(timeline_number * 8, height/2, diameter * 1, diameter * 1);
              
              // * Experiment Circles in place *
              //canvas.ellipse(width/2, height/2, diameter*2, diameter*2);
              
              
              canvas.endDraw();
              image(canvas, 0, 0, width, height);
              
              timeline_number++;
              angle = angle + angleSpeed;
           }
        
          // * save frame *
          if (recording) {
            
            // * save dataTable *
            saveData(dataTable);
            
            String frame_number_string = nf(frame_number, 4);
            String animationFileLocation_and_Name = animationFileLocation + currentDate + '/' + "shot-" + currentDateAndTime + '/' + "shot-" + currentDateAndTime + "-" + frame_number_string + ".png";
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
  if (key == ' ' && gameState == 1) {
    pauseScreen = !pauseScreen;
    if (pauseScreen) {
      noLoop();
    } else {
      loop();
    }
  }
  
  if ((key == 's' || key == 'S') && gameState == 1) {
    String fileName = get_date_and_time();
    String screenshotFileLocation_and_Name = screenshotsFileLocation + currentDate + '/' + fileName + ".png";
    //save(screenshotFileLocation_and_Name);
    canvas.save(screenshotFileLocation_and_Name);
    myPort.write('S');
    println("S");
  }
}

public void mouseClicked() {
  if (gameState == 0) {
    eraseWelcomeIntructions();
    gameState = 1;
  }
}

public void serialSetup() {
  String portName = Serial.list()[5]; // change to match port
  //printArray(Serial.list()); // find what serial port to use
  
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}

public void initScreen() {
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
  return s;
}

public String get_date() {
  String[] date = new String[3];
  date[0] = String.valueOf(month());
  date[1] = String.valueOf(day());
  date[2] = String.valueOf(year());
  
  String s = join(date, "-");
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

public void saveData(Table t) {
  TableRow newRow = t.addRow();
  newRow.setString("date", currentDate);
  newRow.setString("time", get_time());
  
  for (int i = 0; i < accel_data.length; i++) {
    newRow.setInt("accel_" + axis_label[i], Integer.parseInt(accel_data[i]));
  }
  
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

public int[] polarToRectPixels(int radius, float angle) {
  int x = round(radius * cos(angle * PI / 180));
  int y = round(radius * sin(angle * PI / 180));
  return new int[] {x, y};
}

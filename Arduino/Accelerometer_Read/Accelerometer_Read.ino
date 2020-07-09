// Accelerometer_Read.ino
// Author: Fosse Lin-Bianco
// Purpose: To test receiving analog data from the
//    ADXL335 LilyPad accelerometer sensor and display
//    X, Y, and Z values on the Serial Monitor.
// Hardware: 1) LilyPad Arduino USB + ADXL335 sensor
//    (connected to port A2, A3, A4 or X, Y, and Z, respectively)

#define Accel_X_PIN A2
#define Accel_Y_PIN A3
#define Accel_Z_PIN A4

int Accel_X = 0;
int Accel_Y = 0;
int Accel_Z = 0;

void setup() {
  pinMode(Accel_X_PIN, INPUT);
  pinMode(Accel_Y_PIN, INPUT);
  pinMode(Accel_Z_PIN, INPUT);
  Serial.begin(9600);
}

void loop() {
  Accel_X = analogRead(Accel_X_PIN) - 510;
  Accel_Y = analogRead(Accel_Y_PIN) - 490;
  Accel_Z = analogRead(Accel_Z_PIN) - 615;
//  Serial.print(Accel_X);
//  Serial.print("\t");
//  Serial.print(Accel_Y);
//  Serial.print("\t");
//  Serial.print(Accel_Z);
//  Serial.println();

  Serial.println(Accel_X);

//  Serial.println(random(300));
  
  delay(50);
}

#include <SoftwareSerial.h>
#define Accel_PIN A3

SoftwareSerial mySerial(11, 10); // RX, TX



void setup() {
  pinMode(Accel_PIN, OUTPUT);

  Serial.begin(9600);
  Serial.println("Goodnight Jooeun!");
  mySerial.begin(9600);
  mySerial.println("Hello, Jooeun?");
}

byte i;

void loop() { // run over and over
  i++;
  Serial.println(i);
  mySerial.write(i);
  analogWrite(Accel_PIN, i);
  delay(1000);
}

/*
3. Ensure that processing receive data from Arduino, by checking the display on the console.

4. Then, combine all of the Arduino codes together!


[Final Arduino Code]

#include

SoftwareSerial mySerial(11,10);

int myLed[] = {A4, A3, A2};

int sound[] = {523, 539, 587}; // C,D,E

int lightScope[]={40,100,150,200};

int i = 0;

int sensor = A5;

byte val; //save variable

int buzzerPin = 2;

int a = Serial.read();

void setup() {

Serial.begin(9600);

for (i = 0; i < 3; i++) {

pinMode(myLed[i], OUTPUT);

}

mySerial.begin(9600);//test1

}

void loop() {

mySerial.write(i++);

int sensorValue = analogRead(sensor/4);

Serial.write(sensorValue/4);

mySerial.write(sensorValue/4);

delay(100);

if (sensorValue < 20) { // Tur all the LED off, if the value is higher than 40

digitalWrite(myLed[i], LOW);

noTone(buzzerPin);

}

else if (sensorValue > lightScope[0], sensorValue < lightScope[1] ) {

lightPin(myLed[0], 100);

tone(buzzerPin, 523, 1000);

delay(100);

}

else if (sensorValue > lightScope[1], sensorValue < lightScope[2]) {

lightPin(myLed[1], 100);

tone(buzzerPin, 587, 1000);

delay(100);

}

else if (sensorValue > lightScope[2], sensorValue < lightScope[3]) {

lightPin(myLed[2], 100);

tone(buzzerPin, 659, 1000);

delay(100);

}

else

{

light();

}

}

void light() {

for (i = 0; i < 3; i++) {

digitalWrite(myLed[i], LOW);

noTone(buzzerPin);

delay(100);

}

}

void lightPin(int ledPin, int ledDelay) {

digitalWrite(ledPin, HIGH);

delay(ledDelay);

digitalWrite(ledPin, LOW);

delay(ledDelay);

}
*/

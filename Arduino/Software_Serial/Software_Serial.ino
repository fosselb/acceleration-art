#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11); // rx, tx

void setup() {
  Serial.begin(9600);
  mySerial.begin(9600);
}

byte i = 0x55;

void loop() {
  mySerial.write(i);
  delay(500);
}

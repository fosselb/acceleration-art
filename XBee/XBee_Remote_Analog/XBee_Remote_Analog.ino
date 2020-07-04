// XBee_Remote_Analog.ino
// Author: Fosse Lin-Bianco
// Purpose: To receive analog data from a remote XBee
//    and print values to Serial Monitor. Data generated from
//    XCTU software.
// Hardware: 1) XBee + XBee Shield + Arduino RedBoard
//           2) XBee + Dongle

#include <SoftwareSerial.h>

char startByte = 0x7E;
int dataCount = 0;

SoftwareSerial XBee(2, 3); // XBee DOUT, IN - Arduino pin 2, 3 (RX, TX)

void setup() {
  XBee.begin(9600);
  Serial.begin(9600);
}

void loop() {
//  if (XBee.available()) {
//    //Serial.write(XBee.read());
////    Serial.print(XBee.read());
//    
////    Serial.print(XBee.read(), HEX);
////    Serial.println();
//  }

//  if (XBee.available()) {
//    if (XBee.read() == 0x7E) {
//      for (int i = 0; i < 22; i++) {
//      Serial.print(XBee.read(), HEX);
//      Serial.print(",");
//      }
//    }
//    Serial.println();
//  }

//  if (XBee.available()) {
//    Serial.print("Serial.print():");
//    Serial.print(XBee.read());
//    Serial.println();
//    Serial.print("Serial.print() with HEX:");
//    Serial.print(XBee.read(), HEX);
//    Serial.println();
//  }

//  char c = 0x7E;
//  Serial.println(c, HEX);
//  Serial.println(c == 0x7F);
//  delay(1000);
  
  if (XBee.available()) {
//    char current = XBee.read();
//    if (current == 0x7E) {
//      Serial.println();
//    }
//    
//    for (int i = 0; i < 21; i++) {
//      Serial.print(current, HEX);
//      Serial.print(",");
//    }

    char current = XBee.read();
    if (current == 0x7E) {
      Serial.println();
      Serial.println();
      Serial.println("Start:");
      dataCount = 0;
    }
    
    
    Serial.print(current, HEX);
    Serial.print(",");
    dataCount++;

    if (dataCount == 8) {
      Serial.print("*");
      Serial.println();
      byte analog_MSB = XBee.read();
      byte analog_LSB = XBee.read();
      int analog_reading = (analog_MSB * 256) + analog_LSB;
      Serial.println(analog_reading);
      dataCount = 0;
    } else if (dataCount == 10) {
      Serial.print("*");
    }
  }
}

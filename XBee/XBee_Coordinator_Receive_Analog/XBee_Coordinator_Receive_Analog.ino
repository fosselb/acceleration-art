// XBee_Coordinator_Receive_Analog.ino
// Author: Fosse Lin-Bianco
// Purpose: To receive analog data from a remote XBee
//    and print DECIMAL value to Serial Monitor. Data generated from
//    XCTU software.
// Hardware: 1) XBee + XBee Shield + Arduino RedBoard
//           2) XBee + Dongle

#include <SoftwareSerial.h>

char startByte = 0x7E;
int dataCount = 0;
byte analog_MSB;
byte analog_LSB;
int analog_reading;

SoftwareSerial XBee(2, 3); // XBee DOUT, IN - Arduino pin 2, 3 (RX, TX)

void setup() {
  XBee.begin(9600);
  Serial.begin(9600);
}

void loop() {
  if (XBee.available()) {
//    char current = XBee.read();
    char current = Serial.read();
    if (current == 0x7E) {
//      Serial.println();
      Serial.println();
      Serial.println("Start:");
      dataCount = 0;
    }

    dataCount++;

// * To view all the bytes coming in *
    Serial.print(current, HEX);
    Serial.print(",");
    
// * To view a nibble of analog data (0xXXXX) *
//    if (dataCount == 9) {
//      analog_MSB = current;
//    } else if (dataCount == 10) {
//      analog_LSB = current;
//      analog_reading = (analog_MSB * 256) + analog_LSB; // shift MSB, combine MSB and LSB
//      Serial.println(analog_reading);
//    }

  }
}

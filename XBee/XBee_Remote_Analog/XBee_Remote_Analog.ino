// XBee_Remote_Analog.ino
// Author: Fosse Lin-Bianco
// Purpose: To receive analog data from a remote XBee
//    and print values to Serial Monitor. Data generated from
//    XCTU software.
// Hardware: 1) XBee + XBee Shield + Arduino RedBoard
//           2) XBee + Dongle

#include <SoftwareSerial.h>

SoftwareSerial XBee(2, 3); // XBee DOUT, IN - Arduino pin 2, 3 (RX, TX

void setup() {
  XBee.begin(9600);
  Serial.begin(9600);
}

void loop() {
  if (XBee.available()) {
    Serial.write(XBee.read());
  }
}

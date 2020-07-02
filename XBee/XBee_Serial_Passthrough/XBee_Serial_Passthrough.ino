//XBee_Serial_Passthrough.ino
// https://learn.sparkfun.com/tutorials/xbee-shield-hookup-guide?_ga=2.1755313.182982798.1592628277-1344049908.1588613100
// Purpose: To set up a software serial port to 
//    pass data between an Xbee Shield and the 
//    Arduino Serial Monitor
// Hardware: Xbee Shield in "DLINE" position.
//    This connects Xbee's DOUT and DIN pins to Arduino 2 and 3.

#include <SoftwareSerial.h>

// XBee DOUT (TX) -- pin 2 (Arduino Software RX)
// XBee DIN (RX) -- pin 3 (Arduino Software TX)
SoftwareSerial XBee(2,3); // RX, TX

void setup() {
  XBee.begin(9600);
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()) {
    XBee.write(Serial.read());
  }

  if (XBee.available()) {
    Serial.write(XBee.read());
  }
}

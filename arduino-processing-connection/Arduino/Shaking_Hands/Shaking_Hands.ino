char val;
int LED_PIN = 13;
boolean ledState = LOW;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
  establishContact();       // send a byte to establish contact until receiver responds
}

void loop() {
  if (Serial.available() > 0) {
    val = Serial.read();

    if (val == '1') {
      ledState = !ledState;
      digitalWrite(LED_PIN, ledState);
    }
    delay(50);
  } else {
    Serial.println("Hello, world!");
    delay(50);
  }

}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("A");
    delay(300);
  }
}

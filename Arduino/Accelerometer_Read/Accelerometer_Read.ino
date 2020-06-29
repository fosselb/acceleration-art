#define AXL_PIN A3

void setup() {
  pinMode(AXL_PIN, INPUT);
  Serial.begin(9600);
}

void loop() {
  Serial.println(analogRead(AXL_PIN));
  delay(100);
}

void setup() {
  Serial.begin(9600);               // initialize serial communication
}

void loop() {
  long randomNumber = random(10500);
  Serial.println(randomNumber);
  delay(200);                       // wait 100 ms
}

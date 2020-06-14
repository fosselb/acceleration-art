// MPU-6050 Short Example Sketch
//www.elegoo.com
//2016.12.9

// addition by Michael Schoeffler's code (https://www.youtube.com/watch?v=wTfSfhjhAU0)

#include<Wire.h>
#include <MPU6050.h>

const int MPU_addr=0x68;  // I2C address of the MPU-6050
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;

#define LED_LB 2
#define LED_RB 3
#define LED_RT 4
#define LED_LT 5

void setup(){
  pinMode(LED_LB, OUTPUT);
  pinMode(LED_RB, OUTPUT);
  pinMode(LED_RT, OUTPUT);
  pinMode(LED_LT, OUTPUT);
  digitalWrite(LED_LB, LOW);
  digitalWrite(LED_RB, LOW);
  digitalWrite(LED_RT, LOW);
  digitalWrite(LED_LT, LOW);
  
  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  Serial.begin(9600);
}
void loop(){
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr,14,true);  // request a total of 14 registers
  AcX=Wire.read()<<8|Wire.read();  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)    
  AcY=Wire.read()<<8|Wire.read();  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  AcZ=Wire.read()<<8|Wire.read();  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
  Tmp=Wire.read()<<8|Wire.read();  // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
  GyX=Wire.read()<<8|Wire.read();  // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  GyY=Wire.read()<<8|Wire.read();  // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  GyZ=Wire.read()<<8|Wire.read();  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
//  Serial.print("AcX = "); Serial.print(AcX);
//  Serial.print(" | AcY = "); Serial.print(AcY);
//  Serial.print(" | AcZ = "); Serial.print(AcZ);
//  Serial.print(" | Tmp = "); Serial.print(Tmp/340.00+36.53);  //From the datasheet of MPU6050, we can know the temperature formula
//  Serial.print(" | GyX = "); Serial.print(GyX);
//  Serial.print(" | GyY = "); Serial.print(GyY);
//  Serial.print(" | GyZ = "); Serial.println(GyZ);

Serial.println(GyX);

  if (AcX < 1000 && AcY < -8000) {
    digitalWrite(LED_LB, HIGH);
    digitalWrite(LED_RB, HIGH);
    digitalWrite(LED_RT, LOW);
    digitalWrite(LED_LT, LOW);
  } else if (AcX < 1000 && AcY > 8000) {
    digitalWrite(LED_LB, LOW);
    digitalWrite(LED_RB, LOW);
    digitalWrite(LED_RT, HIGH);
    digitalWrite(LED_LT, HIGH);
  } else if (AcX > 8000 && AcY < 1000) {
    digitalWrite(LED_LB, LOW);
    digitalWrite(LED_RB, HIGH);
    digitalWrite(LED_RT, HIGH);
    digitalWrite(LED_LT, LOW);
  } else if (AcX < -8000 && AcY < 1000) {
    digitalWrite(LED_LB, HIGH);
    digitalWrite(LED_RB, LOW);
    digitalWrite(LED_RT, LOW);
    digitalWrite(LED_LT, HIGH);
  } else {
    digitalWrite(LED_LB, LOW);
    digitalWrite(LED_RB, LOW);
    digitalWrite(LED_RT, LOW);
    digitalWrite(LED_LT, LOW);
  }
  
  delay(100);
}

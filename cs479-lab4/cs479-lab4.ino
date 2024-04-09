#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

Adafruit_MPU6050 mpu;


// change these 4 depending on pins used (Tyler: 2,3,1,0)
int MF_Pin = 2; //MF, top left
int LF_Pin = 3; //LF, top right
int MM_Pin = 1; //MM, middle
int HEEL_Pin = 0; //HEEL, bottom

// (pranav: 0,2,1,3)
// int MF_Pin = 0; //MF, top left
// int LF_Pin = 1; //LF, top right
// int MM_Pin = 2; //MM, middle
// int HEEL_Pin = 3; //HEEL, bottom

int MF;
int LF;
int MM;
int HEEL;
float cool;
int zero;
float MFP;

// change these 4 depending on pins used   (Tyler: 3,5,9,11)
const int MF_LED_Pin = 3;  // LED pin for MF
const int LF_LED_Pin = 5;  // LED pin for LF
const int MM_LED_Pin = 9;  // LED pin for MM
const int HEEL_LED_Pin = 11; // LED pin for HEEL

// (pranav: 3,5,6,9)
// const int MF_LED_Pin = 3;  // LED pin for MF
// const int LF_LED_Pin = 5;  // LED pin for LF
// const int MM_LED_Pin = 6;  // LED pin for MM
// const int HEEL_LED_Pin = 9; // LED pin for HEEL


void setup() {
  //fsr
  Serial.begin(115200);
  pinMode(MF_LED_Pin, OUTPUT);
  pinMode(LF_LED_Pin, OUTPUT);
  pinMode(MM_LED_Pin, OUTPUT);
  pinMode(HEEL_LED_Pin, OUTPUT);
  //----------------------------------
  // MPU6050
  while (!Serial)
    delay(10); // will pause Zero, Leonardo, etc until serial console opens

  // Serial.println("Adafruit MPU6050 test!");

  // Try to initialize!
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  // Serial.println("MPU6050 Found!");

  //setupt motion detection
  mpu.setHighPassFilter(MPU6050_HIGHPASS_0_63_HZ);
  mpu.setMotionDetectionThreshold(1);
  mpu.setMotionDetectionDuration(20);
  mpu.setInterruptPinLatch(true);	// Keep it latched.  Will turn off when reinitialized.
  mpu.setInterruptPinPolarity(true);
  mpu.setMotionInterrupt(true);

  delay(100);
}

void loop() { //prints by : HEEL, Medial Mid-foot, Medial forefoot, lateral forefoot
              // MF, LF, MM, HEEL
  MF = analogRead(MF_Pin);
  LF = analogRead(LF_Pin);
  MM = analogRead(MM_Pin);
  HEEL = analogRead(HEEL_Pin);

  // Map analog readings to PWM range (0-255)
  int MF_brightness = map(MF, 0, 1023, 0, 255);
  int LF_brightness = map(LF, 0, 1023, 0, 255);
  int MM_brightness = map(MM, 0, 1023, 0, 255);
  int HEEL_brightness = map(HEEL, 0, 1023, 0, 255);



   if (MF < 10){ // did this because my force sensor keeps printing numbers from 1-4
    MF = 0;
    Serial.print(MF);
  }
  else {
    Serial.print(MF);
  }

  Serial.print(" ");
  Serial.print(LF);

  Serial.print(" ");
  Serial.print(MM);

  Serial.print(" ");

  if (HEEL < 10){ // did this because my force sensor keeps printing numbers from 1-4
    HEEL = 0;
    Serial.print(HEEL);
    Serial.print(" ");
  }
  else {
    Serial.print(HEEL);
    Serial.print(" ");
  }
  // Serial.print(HEEL);

  if(mpu.getMotionInterruptStatus()) {
    /* Get new sensor events with the readings */
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);
    cool = a.acceleration.x;
    Serial.print(cool);
    Serial.println(" ");
  }
  else{
    zero = 0;
    Serial.print(zero);
    Serial.println(" ");
  }
  // MFP = ((MM + MF) * 100)/(MM + MF + LF + HEEL + 0.001);
  // Serial.println(" ");
  // // Serial.print()
  // Serial.print((float)((MM + MF) * 100))/(float)(MM + MF + LF + HEEL + 0.001);


  // Update LED brightness
  analogWrite(MF_LED_Pin, MF_brightness);
  analogWrite(LF_LED_Pin, LF_brightness);
  analogWrite(MM_LED_Pin, MM_brightness);
  analogWrite(HEEL_LED_Pin, HEEL_brightness);

  delay(100);
}

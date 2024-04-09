import processing.serial.*;
int MF;
int LF;
int MM;
int HEEL;
float Moving;
String current;
int currentPage = 3; // 1 for input page, 2 for heatmap page, 4 for special/running page
PImage home_icon;

Serial myPort;
void setup() {
  String portName = Serial.list()[1];
  print(Serial.list());
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil('\n');
  
  size(800, 600);
  textAlign(LEFT, CENTER);
  input_setup();
  heat_map_setup();
  running_setup();
  home_setup();
}
void serialEvent(Serial myPort){
  String tempVal = myPort.readStringUntil('\n');
  if (tempVal != null){
    String[] values = split(tempVal, ' ');
    MF = int(values[0]);
    LF = int(values[1]);
    MM = int(values[2]);
    HEEL = int(values[3]);
    Moving = float(values[4]);
    
    float MFP = ((MM + MF) * 100)/(MM + MF + LF + HEEL + 0.001);
    println(MFP); 
    profile(MFP);
  }  
}



Boolean walking(float Moving){
  if (Moving == 0){
  return false;
  }
  else {
  return true;
  }
}



void profile(float x){
  if (x <= 5){
    current = "Walking on the heel";
  }
  else if (x > 5 && x < 43){
    current = "In-toeing";
  }
  else if (x >= 43 && x <= 57){
    current = "Normal Gait";
  }
  else if (x > 57 && x < 95){
    current = "Out-toeing";
  }
  else {
  current = "Tiptoeing";
  }
}

void draw() {
  background(255);
  
  if (currentPage == 1) {
    drawInputPage();
  } else if (currentPage == 2) {
    drawHeatmapPage(current);
  }
  else if (currentPage == 3){
    home_draw();
  }
  else if (currentPage == 4){
    drawRunningPage();
  }
}


void mousePressed() {
  // Only change x based on icon clicks if x is currently 3
  if (currentPage == 3) {
    // Check if click is within the bounds of the input icon
    if (mouseX >= 100 && mouseX <= 200 && mouseY >= (height/3+40) && mouseY <= (height/3+140)) {
      currentPage = 1; // Input icon clicked
    } 
    // Check if click is within the bounds of the heat map icon
    else if (mouseX >= 340 && mouseX <= 440 && mouseY >= (height/3+40) && mouseY <= (height/3+140)) {
      currentPage = 2; // Heat map icon clicked
    }
    // Check if click is within the bounds of the running icon
    else if(mouseX >= 580 && mouseX <= 680 && mouseY >= (height/3+40) && mouseY <= (height/3+140)){
      currentPage = 4;
    }
  }
  else if (currentPage == 1){
   //Check which input field is selected
      for (int i = 0; i < inputPrompts.length; i++) {
        if (mouseX >= 200 && mouseX <= 400 && mouseY >= 50 + i * 50 && mouseY <= 80 + i * 50) {
          activeField = i;
          inputFieldsSelected[i] = true;
        } else {
          inputFieldsSelected[i] = false;
        }
      }
    
      // Check if 'Proceed' button is pressed and all fields are filled
      if (mouseX >= 50 && mouseX <= 150 && mouseY >= 350 && mouseY <= 380) {
        boolean allFilled = true;
        for (String value : inputValues) {
          if (value.equals("")) {
            allFilled = false;
            break;
          }
        }
        if (allFilled) {
          currentPage = 2;
        }
       }
  
  }
  // Check for clicks within the bounds of the home icon
  if (mouseX >= 750 && mouseX <= 800 && mouseY >= 10 && mouseY <= 60) {
    currentPage = 3; // Home icon clicked
  }
}

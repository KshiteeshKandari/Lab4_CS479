String[] inputPrompts = {"Step Length", "Stride Length"};
String[] inputValues = new String[inputPrompts.length];
boolean[] inputFieldsSelected = new boolean[inputPrompts.length];
int activeField = -1;
PImage input_bg;
PImage left_arrow;
PImage left_arrow2;
int stepCount = 0;

int Cade= 0;
int threshold = 650; // Replace with the value above which a step is detected. This needs to be calibrated.
long lastStepTime = 0; // To prevent counting multiple steps for the same foot strike
int debounceTime = 1000;// Milliseconds to wait before counting a new step to debounce the step count
boolean stepDetected = false;


void input_setup(){
  home_icon = loadImage("home.png");
  left_arrow = loadImage("lf1.png");
  left_arrow2 = loadImage("lf2.png");
  textSize(16);
  for (int i = 0; i < inputValues.length; i++) {
    inputValues[i] = ""; // Initialize input fields with empty strings
    inputFieldsSelected[i] = false;
  }
  input_bg = loadImage("input_bg.png");
}
void drawInputPage() {
  background(input_bg);
    textSize(18);
   textAlign(LEFT, CENTER);
  image(home_icon,750,10,50,50);
  for (int i = 0; i < inputPrompts.length; i++) {
    if (inputFieldsSelected[i]) {
      fill(230); // Highlight the selected input field
    } else {
      fill(255);
    }
    rect(200, 50 + i * 50, 200, 30);
    fill(0);
    text(inputPrompts[i] + ":", 50, 65 + i * 50);
    text(inputValues[i], 210, 65 + i * 50);   
    
  }
//if (HEEL > 550 && HEEL < 580   && MF == 0 && MM == 0 && LF == 0){
//  stepCount += 2;
//}
if (HEEL > threshold && !stepDetected) {
    if (millis() - lastStepTime > debounceTime) { // Debounce to prevent multiple counts for one step
      stepCount++; // Increment the step count
      print("Step detected!");
      print("Total steps: ");
      stepDetected = true; // Set the step detected flag
      lastStepTime = millis(); // Update the last step time
    }
  } else if (HEEL < threshold) {
    stepDetected = false; // Reset the step detected flag when the value falls below threshold
  }

//while(MF > 0)
  
  
  // Instructions for the user
  text("Click on a field to enter the corresponding data. Press the icon to go to heat maps.", 50, 300);
  
  // Proceed button
  drawProceedButton();
}

void drawProceedButton() {
  // Check if all fields are filled
  boolean allFilled = true;
  for (String value : inputValues) {
    if (value.equals("")) {
      allFilled = false;
      break;
    }
  }
  
  if (allFilled) {
    image(left_arrow2,65,345,50,50);
    Cade = 264/ int (inputValues[0]);
    text("Your Cadence is: "+ Cade, width/2+200,400);
    text("Yor Step Count is: "+ stepCount, width/2+200,500);
    
    //text("Proceed", 55, 365);
  } else {
    image(left_arrow,65,345,50,50);
  }
  //rect(50, 350, 100, 30);
  //fill(0);
  
}



//void mousePressed() {
//  // Check which input field is selected
//  for (int i = 0; i < inputPrompts.length; i++) {
//    if (mouseX >= 200 && mouseX <= 400 && mouseY >= 50 + i * 50 && mouseY <= 80 + i * 50) {
//      activeField = i;
//      inputFieldsSelected[i] = true;
//    } else {
//      inputFieldsSelected[i] = false;
//    }
//  }
  
//  // Check if 'Proceed' button is pressed and all fields are filled
//  if (mouseX >= 50 && mouseX <= 150 && mouseY >= 350 && mouseY <= 380) {
//    boolean allFilled = true;
//    for (String value : inputValues) {
//      if (value.equals("")) {
//        allFilled = false;
//        break;
//      }
//    }
//    if (allFilled) {
//      currentPage = 2;
//    }
//  }
//}

void keyPressed() {
  if (activeField != -1) {
    if (key == BACKSPACE) {
      if (inputValues[activeField].length() > 0) {
        inputValues[activeField] = inputValues[activeField].substring(0, inputValues[activeField].length() - 1);
      }
    } else if ((key >= '0' && key <= '9') || key == '.' || key == ENTER) {
      if (key != ENTER) {
        inputValues[activeField] += key;
      } else {
        inputFieldsSelected[activeField] = false;
        activeField = -1; // Deselect the active input field
      }
    }
  }
}

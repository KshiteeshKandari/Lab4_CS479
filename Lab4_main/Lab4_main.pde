int currentPage = 3; // 1 for input page, 2 for heatmap page
PImage home_icon;

void setup() {
  size(800, 600);
  textAlign(LEFT, CENTER);
  input_setup();
  heat_map_setup();
  home_setup();
}

void draw() {
  background(255);
  
  if (currentPage == 1) {
    drawInputPage();
  } else if (currentPage == 2) {
    drawHeatmapPage();
  }
  else if (currentPage == 3){
    home_draw();
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

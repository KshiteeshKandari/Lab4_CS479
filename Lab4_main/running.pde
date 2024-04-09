void running_setup() {
  // Load images for UI elements
  img = loadImage("foot2.png");
  home_icon = loadImage("home.png");
  
  // Initialize sensor data storage
  int sensors = 4;
  fsrValues = new int[sensors][20]; // Storing recent sensor readings for smoothing
  
  // Initialize historical sensor data for trend analysis
  fsrHistory = new ArrayList<ArrayList<Integer>>();
  for (int i = 0; i < sensors; i++) {
    fsrHistory.add(new ArrayList<Integer>());
  }

  // Set visualization parameters
  heatmapDiameter = width / 12; // Diameter for heatmap circles
  frameRate(10); // Reduce frame rate to diminish flicker
}

void drawRunningPage() {
  textAlign(LEFT, CENTER);
  textSize(50); // Set main message text size
  
  background(img);
  image(home_icon, 750, 10, 50, 50); // Re-display icons on redraw
  
  // Update sensor values with most recent readings
  updateSensorValues();
  
  // Evaluate running form based on the latest sensor data
  evaluateRunningForm();

  // Optionally, draw heatmaps or additional UI elements
  if (currentPage == 4) {
    drawHeatmaps();
  }
}

void updateSensorValues() {
  // Simulate or update fsrValues with actual sensor readings here
  fsrValues[0][fsrValues[0].length - 1] = MF; // Most recent MF value
  fsrValues[1][fsrValues[1].length - 1] = LF; // Most recent LF value
  fsrValues[2][fsrValues[2].length - 1] = MM; // Most recent MM value
  fsrValues[3][fsrValues[3].length - 1] = HEEL; // Most recent HEEL value

  // Add to historical data for trend analysis
  for (int j = 0; j < fsrValues.length; j++) {
    int sum = 0;
    for (int value : fsrValues[j]) {
      sum += value;
    }
    int average = sum / fsrValues[j].length;
    fsrHistory.get(j).add(average);
    // Limit history size
    if (fsrHistory.get(j).size() > 50) fsrHistory.get(j).remove(0);
  }
}

void evaluateRunningForm() {
  // Initialize counts for each type of foot strike
  int foreStrikeCount = 0, midStrikeCount = 0, heelStrikeCount = 0;

  // Analyze the pressure distribution for each set of sensor readings
  for (int i = 0; i < fsrValues[0].length; i++) {
    int totalPressure = fsrValues[0][i] + fsrValues[1][i] + fsrValues[2][i] + fsrValues[3][i];
    if(totalPressure == 0) continue; // Avoid division by zero

    // Calculate pressure percentages
    float forePressurePercent = (fsrValues[0][i] + fsrValues[1][i]) / (float) totalPressure;
    float midPressurePercent = fsrValues[2][i] / (float) totalPressure;
    float heelPressurePercent = fsrValues[3][i] / (float) totalPressure;

    // Classify foot strike based on the highest pressure percentage
    if (forePressurePercent > midPressurePercent && forePressurePercent > heelPressurePercent) {
      foreStrikeCount++;
    } else if (midPressurePercent > heelPressurePercent) {
      midStrikeCount++;
    } else {
      heelStrikeCount++;
    }
  }

  // Determine the dominant foot strike pattern
  if (foreStrikeCount > midStrikeCount && foreStrikeCount > heelStrikeCount) {
    displayFeedback("Slow Down!!", "You are currently placing excess strain on your calves and Achilles tendons.");
  } else if (midStrikeCount > heelStrikeCount) {
    displayFeedback("Keep up the good work!!", "You are currently placing optimal strain on your joints!");
  } else {
    displayFeedback("Warning!!", "You are currently placing excess strain on your knees and shins. To fix this, try to shorten your stride length.");
  }
}


void displayFeedback(String strikeType, String advice) {
  //println(strikeType + ": " + advice); // Adjust this to display on your UI
  //text(strikeType+ ": "+advice,width/2,height/2);
  showFeedbackMessage(strikeType, advice);
}

void showFeedbackMessage(String title, String message) {
  // Assuming 'img' is your background image already drawn, including the foot visualization

  fill(0); // Set text color to black, or choose another color that contrasts with the background
  
  // Title
  textSize(50); // Adjust text size as needed
  float titleX = width - textWidth(title) - 20; // 20 pixels padding from the right edge
  float titleY = height / 4; // Position the title at one-quarter height from the top
  
  text(title, titleX, titleY);
  
  // Message - break it into lines if needed
  textSize(25); // Adjust text size as needed for the message
  float messageX = titleX; // Align message X to title X
  float messageY = titleY + 60; // Start the message 60 pixels below the title
  
  String[] words = message.split(" ");
  String line = "";
  
  for (String word : words) {
    float wordWidth = textWidth(line + word + " ");
    // Check if adding the next word exceeds the width available
    if (wordWidth < (width - messageX - 20)) { // 20 pixels padding from the right edge
      line += word + " ";
    } else {
      // Draw the line and start a new one
      text(line, messageX, messageY);
      line = word + " ";
      messageY += 30; // Adjust line spacing as needed
    }
  }
  
  // Draw the last line
  if (!line.equals("")) {
    text(line, messageX, messageY);
  }
}


void drawHeatmaps() {
  // Your existing heatmap drawing logic here
  // Draw heatmaps for each sensor on the left
    drawCircularHeatmap(fsrValues[0], (width / 4), (height / 5)+40, heatmapDiameter);
    drawCircularHeatmap(fsrValues[1], width / 10, 2 * height / 5, heatmapDiameter);
    drawCircularHeatmap(fsrValues[2], (width / 3)-70, 3 * (height / 7)+40, heatmapDiameter);
    drawCircularHeatmap(fsrValues[3], (width / 4)-30, 4 * (height / 5)+40, heatmapDiameter);
}

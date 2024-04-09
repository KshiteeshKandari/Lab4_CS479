void running_setup() {
  
  img = loadImage("foot2.png");
  home_icon = loadImage("home.png");
  // Initialize the FSR values for the heatmap for each sensor
  int sensors = 4;
  fsrValues = new int[sensors][20]; // More sensor points for a smoother gradient

  // Initialize fsrHistory
  fsrHistory = new ArrayList<ArrayList<Integer>>();
  for (int i = 0; i < sensors; i++) {
    fsrHistory.add(new ArrayList<Integer>());
  }

  // Set the diameter for the individual heatmaps
  heatmapDiameter = width / 12; // Choose an appropriate size for the individual heatmaps

  frameRate(10); // Reduce the frame rate to make it less flickery
}

void drawRunningPage() {
  int foreStrike = 0;
  int midStrike = 0;
  int heelStrike = 0;
  background(img);
  image(home_icon,750,10,50,50);

  // Simulate live FSR values updating for each sensor
  for (int j = 0; j < fsrValues.length; j++) {
    image(home_icon,750,10,50,50);
    int avgValue = 0; // Calculate average for a smoother graph
    for (int i = 0; i < fsrValues[j].length; i++) {
      fsrValues[j][i] = (int)random(minFSRValue, maxFSRValue + 1); // Random values within the expected range
      
      if(fsrValues[0][i] > fsrValues[3][i] || fsrValues[1][i] > fsrValues[3][i]){
        foreStrike = foreStrike+1;
      }
      else if(fsrValues[2][i] > fsrValues[3][i]){
        midStrike = midStrike +1;
      }
      else{
        heelStrike = heelStrike +1;
      }
      
      if(foreStrike > midStrike && foreStrike > heelStrike){
        background(img);
        fill(0);
        textSize(50);
        text("Slow Down!!", 3 * (width / 4)-150, 2 * (height / 5)-70);
        textSize(25);
        text("You are currently placing excess", 3 * (width / 4)-200, 2 * (height / 5)-20);
        text("strain on your calves and Achilles tendons", 3 * (width / 4)-250, 2 * (height / 5));
        
      }
      else if(heelStrike > midStrike && heelStrike > foreStrike){
        background(img); //this may not update idk lol tbh
        fill(0);
        textSize(50);
        text("Warning!!", 3 * (width / 4)-150, 2 * (height / 5)-70);
        textSize(25);
        text("You are currently placing excess", 3 * (width / 4)-200, 2 * (height / 5)-20);
        text("strain on your knees and shins.", 3 * (width / 4)-200, 2 * (height / 5));
        text("To fix this, try to shorten your stride length.", 3 * (width / 4)-270, 2 * (height / 5)+20);
      }
      else{
        background(img);
        fill(0);
        textSize(50);
        text("Keep up the good work!!", 3 * (width / 4)-300, 2 * (height / 5)-70);
        textSize(25);
        text("You are currently placing optimal", 3 * (width / 4)-200, 2 * (height / 5)-20);
        text("strain on your joints!", 3 * (width / 4)-200, 2 * (height / 5));
      }
   
      avgValue += fsrValues[j][i];
    }
    avgValue /= fsrValues[j].length;
    fsrHistory.get(j).add(avgValue); // Add average value to history
    if (fsrHistory.get(j).size() > 50) { // Limit history size to keep the graph manageable
      fsrHistory.get(j).remove(0);
    }
  }

  if (currentPage == 4) {
    // Draw heatmaps for each sensor on the left
    drawCircularHeatmap(fsrValues[0], (width / 4), (height / 5)+40, heatmapDiameter);
    drawCircularHeatmap(fsrValues[1], width / 10, 2 * height / 5, heatmapDiameter);
    drawCircularHeatmap(fsrValues[2], (width / 3)-70, 3 * (height / 7)+40, heatmapDiameter);
    drawCircularHeatmap(fsrValues[3], (width / 4)-30, 4 * (height / 5)+40, heatmapDiameter);
  }

  
}

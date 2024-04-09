
int minFSRValue = 0; // Minimum expected value for FSR input
int maxFSRValue = 1000; // Maximum expected value for FSR input
int heatmapDiameter; // Diameter of each individual heatmap
int[][] fsrValues; // 2D Array to store FSR values for each sensor
ArrayList<ArrayList<Integer>> fsrHistory; // To store a history of values for drawing the graphs
PImage img;


void heat_map_setup() {
  
  img = loadImage("foot.png");
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

void drawHeatmapPage() {
  background(img);
  image(home_icon,750,10,50,50);

  // Simulate live FSR values updating for each sensor
  for (int j = 0; j < fsrValues.length; j++) {
    int avgValue = 0; // Calculate average for a smoother graph
    for (int i = 0; i < fsrValues[j].length; i++) {
      fsrValues[j][i] = (int)random(minFSRValue, maxFSRValue + 1); // Random values within the expected range
      avgValue += fsrValues[j][i];
    }
    avgValue /= fsrValues[j].length;
    fsrHistory.get(j).add(avgValue); // Add average value to history
    if (fsrHistory.get(j).size() > 50) { // Limit history size to keep the graph manageable
      fsrHistory.get(j).remove(0);
    }
  }

  if (currentPage == 2) {
    // Draw heatmaps for each sensor on the left
    drawCircularHeatmap(fsrValues[0], (width / 4), (height / 5)+40, heatmapDiameter);
    drawCircularHeatmap(fsrValues[1], width / 10, 2 * height / 5, heatmapDiameter);
    drawCircularHeatmap(fsrValues[2], (width / 3)-70, 3 * (height / 7)+40, heatmapDiameter);
    drawCircularHeatmap(fsrValues[3], (width / 4)-30, 4 * (height / 5)+40, heatmapDiameter);

    // Draw line graphs for each sensor on the right
    drawLineGraph(fsrHistory.get(0), 3 * (width / 4)-100, (height / 5)-70);
    drawLineGraph(fsrHistory.get(1), 3 * (width / 4)-100, 2 * (height / 5)-70);
    drawLineGraph(fsrHistory.get(2), 3 * (width / 4)-100, 3 * (height / 5)-70);
    drawLineGraph(fsrHistory.get(3), 3 *(width / 4)-100, 4 * (height / 5)-70);
  }
}

void drawCircularHeatmap(int[] sensorValues, float centerX, float centerY, int diameter) {
  noStroke();
  for (int i = sensorValues.length - 1; i >= 0; i--) {
    float normalizedValue = map(sensorValues[i], minFSRValue, maxFSRValue, 0, 1);
    float currentDiameter = map(i, 0, sensorValues.length, 0, diameter);
    color heatColor = lerpColor(color(255, 165, 0), color(255, 0, 0), normalizedValue);
    fill(heatColor);
    ellipse(centerX, centerY, currentDiameter, currentDiameter);
  }
}

void drawLineGraph(ArrayList<Integer> values, float startX, float startY) {
  float graphWidth = width / 5; // Width of the graph
  float graphHeight = height / 6; // Height of the graph
  stroke(0);
  
  // Draw Y-axis
  line(startX, startY, startX, startY + graphHeight);
  // Draw X-axis
  line(startX, startY + graphHeight, startX + graphWidth, startY + graphHeight);
  
  // Draw graph line
  noFill();
  beginShape();
  for (int i = 0; i < values.size(); i++) {
    float x = map(i, 0, values.size(), startX, startX + graphWidth);
    float y = map(values.get(i), minFSRValue, maxFSRValue, startY + graphHeight, startY);
    vertex(x, y);
  }
  endShape();
  
  // Label Y-axis with min and max FSR values
  textSize(10);
  fill(0);
  textAlign(RIGHT, CENTER);
  text(minFSRValue, startX - 5, startY + graphHeight);
  text(maxFSRValue, startX - 5, startY);
  
  // Label X-axis with "Time" and draw a simple indication of the start and end points
  textAlign(CENTER, TOP);
  text("Start", startX, startY + graphHeight + 5);
  text("Now", startX + graphWidth, startY + graphHeight + 5);
  text("FSR Value", startX - 20, startY + graphHeight / 2); // Additional label for Y-axis
}

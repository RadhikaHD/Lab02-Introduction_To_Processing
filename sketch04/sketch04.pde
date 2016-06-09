FloatTable data;
float dataMin, dataMax;
float plotX1, plotY1; 
float plotX2, plotY2; 
float labelX, labelY;
int rowCount;
int columnCount;
int currentColumn = 0;
int yearMin, yearMax;
int[] years;
int yearInterval = 7;
int volumeInterval = 5;
int volumeIntervalMinor = 1;
PFont plotFont;
PFont LabelFont;
PFont TitleFont;
PFont HighFont;
int StateRecord;
Integrator[] interpolators;
float[] tabLeft, tabRight; // Add above setup( )
float tabTop, tabBottom;
float tabPad = 10;

void setup() { 
  StateRecord = 0;
  size(720, 405);
  data = new FloatTable("milk-tea-coffee.tsv"); 
  rowCount = data.getRowCount();
  columnCount = data.getColumnCount();
  years = int(data.getRowNames()); 
  yearMin = years[0];
  yearMax = years[years.length - 1];
  dataMin = 0;
  dataMax = ceil(data.getTableMax() / volumeInterval) * volumeInterval;
  // Corners of the plotted time series
  plotX1 = 120;
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY = height - 25;
  plotFont = createFont("SansSerif", 20);
  LabelFont = createFont("Georgia", 12);
  TitleFont = createFont("Verdana", 11);
  HighFont = createFont("Georgia", 14);
  textFont(plotFont);
  smooth( );

  interpolators = new Integrator[rowCount];
  for (int row = 0; row < rowCount; row++) {
    float initialValue = data.getFloat(row, 0);
    interpolators[row] = new Integrator(initialValue);
    //interpolators[row].attraction = 0.1; // Set lower than the default
  }
}

void draw() 
{ 
  background(224);
  // Show the plot area as a white box 
  fill(255);
  rectMode(CORNERS);
  noStroke( );
  rect(plotX1, plotY1, plotX2, plotY2);
  drawTitle( );
  drawTitleTabs( );
  drawAxisLabels( );

  for (int row = 0; row < rowCount; row++) {
    interpolators[row].update( );
  }

  drawYearLabels( );
  drawVolumeLabels( );

  noFill();
  stroke(#CC3300);
  strokeWeight(1);
  drawDataLine(0);
  stroke(#CC3300);
  strokeWeight(4);
  drawDataPoints(0);
  drawDataHighlight(0);

  stroke(#0000FF);
  strokeWeight(1);
  drawDataLine(1);
  stroke(#0000FF);
  strokeWeight(4);
  drawDataPoints(1);
  drawDataHighlight(1);

  stroke(#009900);
  strokeWeight(1);
  drawDataLine(2);
  stroke(#009900);
  strokeWeight(4);
  drawDataPoints(2);
  drawDataHighlight(2);
}

void drawTitle()
{ 
  fill(0);
  //textSize(20);
  textFont(TitleFont);
  textAlign(LEFT);
  String title = data.getColumnName(currentColumn);
  text(title, plotX1, plotY1 - 10);
}
void drawAxisLabels() { 
  fill(0);
  //textSize(13);
  textFont(TitleFont);
  textLeading(15);
  textAlign(CENTER, CENTER);
  // Use \n (aka enter or linefeed) to break the text into separate lines.
  text("Gallons\nconsumed\nper capita", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Year", (plotX1+plotX2)/2, labelY);
}
void drawYearLabels() { 
  fill(0);
  //textSize(10);
  textFont(LabelFont);
  textAlign(CENTER, TOP);
  // Use thin, gray lines to draw the grid.
  stroke(224);
  strokeWeight(1);
  for (int row = 0; row < rowCount; row++) {
    if (years[row] % yearInterval == 0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      text(years[row], x, plotY2 + 10);
      line(x, plotY1, x, plotY2);
    }
  }
}
void drawVolumeLabels() { 
  fill(0);
  //textSize(10);
  textFont(LabelFont);
  stroke(128);
  strokeWeight(1);
  for (float v = dataMin; v <= dataMax; v += volumeIntervalMinor) {
    if (v % volumeIntervalMinor == 0) { // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1);
      if (v % volumeInterval == 0) { // If a major tick mark
        if (v == dataMin) {
          textAlign(RIGHT); // Align by the bottom
        } else if (v == dataMax) {
          textAlign(RIGHT, TOP); // Align by the top
        } else {
          textAlign(RIGHT, CENTER); // Center vertically
        }
        text(floor(v), plotX1 - 10, y);
        line(plotX1 - 4, y, plotX1, y); // Draw major tick
      } else {
        // Commented out; too distracting visually
        line(plotX1 - 2, y, plotX1, y); // Draw minor tick
      }
    }
  }
}

void keyPressed() 
{ 
  if (key == '[') 
  {
    currentColumn--;
    if (currentColumn < 0)
    {
      currentColumn = columnCount - 1;
    }
  } else if (key == ']') 
  {
    currentColumn++;
    if (currentColumn == columnCount) 
    {
      currentColumn = 0;
    }
  } else if (key == '1') //dots
  {
    StateRecord = 0;
    /*stroke(#2F4F4F);
     strokeWeight(5);
     drawDataPoints(currentColumn);*/
  } else if (key == '2') //connected dots
  {
    StateRecord = 1;
    /*stroke(#2F4F4F);
     strokeWeight(5);
     drawDataPoints(currentColumn);
     noFill( );
     strokeWeight(2);
     stroke(#2F4F4F);
     drawDataLine(currentColumn); */
  } else if (key == '3') //lines
  {
    StateRecord = 2;
    /* noFill( );
     strokeWeight(4);
     stroke(#2F4F4F);
     drawDataLine(currentColumn);*/
  } else if (key == '4') //filled chart
  {
    StateRecord = 3;
    /*
 noStroke( );
     fill(#FFD700);
     drawDataArea(currentColumn);
     drawYearLabels( );
     */
  } else if (key == '5') //all
  {
    StateRecord = 4;
    /*
  stroke(#2F4F4F);
     strokeWeight(5);
     drawDataPoints(currentColumn);
     noFill( );
     strokeWeight(2);
     stroke(#2F4F4F);
     drawDataLine(currentColumn); 
     drawDataHighlight(currentColumn);   
     noStroke( );
     fill(#FFD700);
     drawDataArea(currentColumn);
     drawYearLabels( ); */
  }
}

void drawDataLine(int col) {
  beginShape( );
  int rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2); 
      float y = map(value, dataMin, dataMax, plotY2, plotY1); 
      vertex(x, y);
    }
  }
  endShape( );
}


void drawDataHighlight(int col)
{
  noFill();
  for (int row = 0; row < rowCount; row++) 
  {
    if (data.isValid(row, col)) 
    {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      if (dist(mouseX, mouseY, x, y) < 3) 
      {
        strokeWeight(10);
        point(x, y);
        //fill(0);
        //textSize(10);
        textAlign(CENTER);
        textFont(HighFont);
        text(nf(value, 0, 2) + " (" + years[row] + ")", x, y-8);
      }
    }
  }
}


void drawDataArea(int col) {
  float value;
  beginShape( );
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) 
    {

      value = interpolators[row]._value;
      //float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      vertex(x, y);
    }
  }
  // Draw the lower-right and lower-left corners.  
  vertex(plotX2, plotY2);
  vertex(plotX1, plotY2);
  endShape(CLOSE);
}

void drawDataPoints(int col) {
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      point(x, y);
    }
  }
}

void drawTitleTabs( ) {
  int col = 0;
  rectMode(CORNERS);
  noStroke( );
  textSize(14);
  textAlign(LEFT);
  // On first use of this method, allocate space for an array
  // to store the values for the left and right edges of the tabs.
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];
  }
  float runningX = plotX1;
  tabTop = plotY1 - textAscent( ) - 15;
  tabBottom = plotY1;

  String title = "Summary Tab";
  tabLeft[col] = runningX;
  float titleWidth = textWidth(title);
  tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
  fill(col == currentColumn ? 255 : 224);
  rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
  // If the current tab, use black for the text; otherwise use dark gray.
  fill(col == currentColumn ? 0 : 64);
  text(title, runningX + tabPad, plotY1 - 10);
}


void mousePressed( ) {
  if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < columnCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
        setCurrent(col);
      }
    }
  }
}

void setCurrent(int col) {
  currentColumn = col;
  for (int row = 0; row < rowCount; row++) {
    interpolators[row].target(data.getFloat(row, col));
  }
}



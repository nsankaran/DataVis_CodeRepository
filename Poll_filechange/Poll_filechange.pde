// Allows the user to select an excel spreadsheet to load.
// Each time the excel file is changed and saved, processing reloads the file and updates the sketch.

import java.util.*;
import java.io.*;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Cell; 
import org.gicentre.utils.stat.*;        // For chart classes.
import org.gicentre.utils.colour.*;
//import java.awt.Frame;
import controlP5.*;

ControlP5 cp5;
String[][] xlsData;
int[][] dataType;
String path;
int l;
SXSSFWorkbook swb=null;
Sheet sheet=null;
InputStream inp=null;
Workbook wb=null;
int sizeX;
int sizeY;
int hdrFlag; // First row header flag (1,0)
int lblFlag; // First column labels flag (1,0)
int[] colType;
int[] rowType;
public int colNum;
public File selection = null;
public float numberboxValue = 100;


void settings() {
  size(displayWidth/2, displayHeight-100); 
}
void setup() {
  smooth();
  selectInput("Select an excel file to process:", "fileSelected");
  cp5 = new ControlP5(this);
}

void fileSelected(File selection) {

  if (selection == null) {
    println("No file selected.");
  } else {
    println("User selected:  " + selection.getAbsolutePath());
    path = selection.getAbsolutePath();

    // read and process excel data
    readExcel(path);
    
    
    cp5.addNumberbox("numberBox")
      .setPosition(100, 160)
      .setSize(100, 20)
      .setScrollSensitivity(6.0)
      .setValue(4) //set default to first numeric column.
      .setRange(lblFlag, dataType.length-1)
      .setLabel("Select a row/column to plot");
    ;
    // create new Timer task
    TimerTask task = new FileWatcher( new File(path));
    // create timer
    Timer timer = new Timer();
    timer.schedule( task, new Date(), 10 ); // check every 10ms
    drawData();
  }
}

void drawData() { 
  //barChart = drawBarChart(xlsData);
  int currVal = int(cp5.getController("numberBox").getValue());
  lineChart = drawXYChart(xlsData, currVal);
} // end drawData()

class FileWatcher extends TimerTask {
  long timeStamp;
  File file;

  FileWatcher( File file ) {
    this.file = file;
    this.timeStamp = file.lastModified();
  }

  // check if file has been modified
  void run() {
    long timeStamp = file.lastModified();

    if ( this.timeStamp != timeStamp ) {
      this.timeStamp = timeStamp;
      onChange(file);
    }
  }

  // load data again
  void onChange( File file ) {
    readExcel(path);
    drawData();
  }
}

void draw() {
  background(0);
  if (barChart!= null) {
    barChart.draw(10, 10, width-20, height-20); 
    fill(200);
  } 
  if (lineChart != null) {
    lineChart.draw(10, height/2, width-20, height/2);
    fill(120);
  }
}

public void numberBox(int colNum) {

  drawData();
  println("a numberbox event. using data from column "+colNum);
}